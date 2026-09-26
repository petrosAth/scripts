#!/usr/bin/env sh
set -eu

# Fresh-machine entry point. Self-contained: it runs before the repo exists, so
# it cannot rely on lib.sh or anything else in the tree. It installs the minimum
# to clone over SSH, clones the dotfiles, and hands off to deploy.sh.
#
# Run with command substitution so stdin stays on the tty (gh auth login and
# every prompt need it) — NOT a pipe:
#
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/petrosAth/scripts/master/deploy/common/bootstrap.sh)"
#
# Override the branch or clone location with the DOTFILES_BRANCH / DOTFILES_DIR
# environment variables.

GITHUB_USER="petrosAth"
DOTFILES_REPO="dotfiles"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/dotfiles}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-master}"

# NO_COLOR disables, FORCE_COLOR/CLICOLOR_FORCE force it on, otherwise emit only
# when stderr is a terminal so logs and pipes stay clean.
_use_color=0
if [ -n "${NO_COLOR:-}" ]; then
    _use_color=0
elif [ -n "${FORCE_COLOR:-}" ] || [ -n "${CLICOLOR_FORCE:-}" ]; then
    _use_color=1
elif [ -t 2 ]; then
    _use_color=1
fi
if [ "$_use_color" -eq 1 ]; then
    C_GREEN=$(tput setaf 2 2> /dev/null || printf '')
    C_YELLOW=$(tput setaf 3 2> /dev/null || printf '')
    C_RED=$(tput setaf 1 2> /dev/null || printf '')
    C_BOLD=$(tput bold 2> /dev/null || printf '')
    C_DIM=$(tput dim 2> /dev/null || printf '')
    C_RESET=$(tput sgr0 2> /dev/null || printf '')
else
    C_GREEN='' C_YELLOW='' C_RED='' C_BOLD='' C_DIM='' C_RESET=''
fi
say() { printf '  %s\xe2\x80\xba  %s%s\n' "$C_DIM" "$*" "$C_RESET" >&2; }
ok() { printf '  %s%s\xe2\x9c\x93%s  %s\n' "$C_GREEN" "$C_BOLD" "$C_RESET" "$*" >&2; }
warn() { printf '  %s%s!%s  %s\n' "$C_YELLOW" "$C_BOLD" "$C_RESET" "$*" >&2; }
die() {
    printf '  %s%s\xe2\x9c\x97%s  %s\n' "$C_RED" "$C_BOLD" "$C_RESET" "$*" >&2
    exit 1
}

# Return the platform token, aborting on anything but Arch or macOS.
detect_os() {
    case "$(uname -s)" in
    Linux)
        command -v pacman > /dev/null 2>&1 \
            || die "Unsupported Linux distribution: this deployer targets Arch only."
        printf 'arch\n'
        ;;
    Darwin) printf 'macos\n' ;;
    *) die "Unsupported operating system: $(uname -s)" ;;
    esac
}

# Convert an internal platform token into a user-facing name. This is duplicated
# intentionally because bootstrap runs before the repository and lib.sh exist.
platform_name() {
    case "$1" in
    arch) printf 'Arch Linux\n' ;;
    macos) printf 'macOS\n' ;;
    *) die "Unsupported platform token: $1" ;;
    esac
}

# Install just enough to clone over SSH: toolchain, git, ssh, gh, stow, curl.
install_prerequisites() {
    case "$OS" in
    arch)
        say "Updating system and installing prerequisites"
        sudo pacman -Syu --needed --noconfirm base-devel git openssh github-cli stow
        ;;
    macos)
        if ! xcode-select -p > /dev/null 2>&1; then
            say "Installing Xcode Command Line Tools"
            xcode-select --install || true
            warn "Finish the Command Line Tools installer."
            printf 'Press Enter to continue... ' >&2
            read -r _
        fi
        if ! command -v brew > /dev/null 2>&1; then
            say "Installing Homebrew"
            /bin/bash -c \
                "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            for prefix in /opt/homebrew /usr/local; do
                [ -x "${prefix}/bin/brew" ] && eval "$("${prefix}/bin/brew" shellenv)" && break
            done
        fi
        say "Installing prerequisites with Homebrew"
        brew install git gh stow
        ;;
    esac
    ok "Prerequisites installed"
}

# True when the SSH key already authenticates to GitHub. GitHub always exits 1
# even on success (trap T10), so match the greeting text, never the exit code.
github_ssh_ok() {
    ssh -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 \
        | grep -q 'successfully authenticated'
}

# Ensure SSH access to GitHub before any clone, since every submodule uses an
# SSH URL. With the SSH protocol, `gh auth login` offers to generate a key (with
# an optional passphrase) or pick an existing one, and uploads it; the
# admin:public_key scope is requested up front so that upload cannot fail. It
# runs even when gh is already logged in, because that login may lack an SSH key.
ensure_github_ssh() {
    if github_ssh_ok; then
        ok "GitHub SSH already authenticated"
        return 0
    fi
    say "Authenticating to GitHub and registering an SSH key"
    command -v gh > /dev/null 2>&1 || die "gh is required but was not installed."
    gh auth login -h github.com -p ssh -s admin:public_key

    github_ssh_ok || die "GitHub SSH authentication still failing; aborting before clone. Check 'gh ssh-key list' and ~/.ssh, then rerun."
    ok "GitHub SSH authenticated"
}

# `gh auth login` writes a regular ~/.config/gh/config.yml, which collides with
# the Stow-managed one and would abort the final linking step. Remove only that
# generated regular file; an existing symlink is the repository's own config,
# and hosts.yml (the credentials) is never touched.
remove_generated_gh_config() {
    gh_config="${HOME}/.config/gh/config.yml"
    if [ -f "$gh_config" ] && [ ! -L "$gh_config" ]; then
        say "Removing gh's generated config.yml so Stow can link the repository copy"
        rm -f -- "$gh_config"
    fi
}

# Clone the dotfiles with submodules, or update an existing checkout in place.
# Never `git init` in $HOME (trap T1) — always a self-contained directory.
clone_dotfiles() {
    if [ -d "${DOTFILES_DIR}/.git" ]; then
        say "Updating existing checkout at ${DOTFILES_DIR}"
        git -C "$DOTFILES_DIR" fetch origin
        git -C "$DOTFILES_DIR" checkout "$DOTFILES_BRANCH"
        git -C "$DOTFILES_DIR" pull --ff-only origin "$DOTFILES_BRANCH"
        git -C "$DOTFILES_DIR" submodule update --init --recursive
    else
        [ -e "$DOTFILES_DIR" ] && die "${DOTFILES_DIR} exists but is not a git repo; move it aside."
        say "Cloning ${DOTFILES_REPO} into ${DOTFILES_DIR}"
        git clone --branch "$DOTFILES_BRANCH" --recurse-submodules \
            "git@github.com:${GITHUB_USER}/${DOTFILES_REPO}.git" "$DOTFILES_DIR"
    fi
    # Leave submodules on their default branch rather than a detached HEAD.
    git -C "$DOTFILES_DIR" submodule foreach 'git checkout master' > /dev/null 2>&1 || true
    ok "Dotfiles ready at ${DOTFILES_DIR}"
}

OS=$(detect_os)
PLATFORM=$(platform_name "$OS")
say "Bootstrapping dotfiles for ${PLATFORM}"
install_prerequisites
ensure_github_ssh
remove_generated_gh_config
clone_dotfiles

# Hand off to the on-disk driver, which sources lib.sh and finishes the install.
exec sh "${DOTFILES_DIR}/Home/Scripts/deploy/common/deploy.sh"
