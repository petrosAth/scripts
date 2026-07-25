#!/usr/bin/env sh
set -eu

# On-disk deployment driver. Runs after bootstrap.sh has installed prerequisites
# and cloned the dotfiles, so lib.sh and the whole repo are available on disk.
#
#   OS packages -> mise runtimes -> default shell -> stow
#
# Set DRY_RUN=1 to print every state-changing command without running it.

SCRIPT_DIR=$(
    unset CDPATH
    cd "$(dirname "$0")" && pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/lib.sh"

DEPLOY_DIR=$(
    unset CDPATH
    cd "${SCRIPT_DIR}/.." && pwd
)
# The dotfiles root is four levels up: deploy/common -> deploy -> Scripts -> Home -> <root>.
DOTFILES=$(
    unset CDPATH
    cd "${DEPLOY_DIR}/../../.." && pwd
)

OS=$(detect_os)

# Provision OS-level packages through the per-platform adapter.
install_packages() {
    case "$OS" in
    arch) run sh "${DEPLOY_DIR}/linux/install.sh" ;;
    macos) run sh "${DEPLOY_DIR}/mac/install.sh" ;;
    esac
}

# Install the runtimes pinned in mise/.config/mise/config.toml. mise reads the
# config through the stowed symlink, but the repo copy works before linking too.
install_mise_runtimes() {
    if ! command -v mise > /dev/null 2>&1; then
        _warn "mise not found on PATH; skipping runtime install."
        return 0
    fi
    _process "Installing mise-managed runtimes"
    run mise install --yes
    _success "mise runtimes installed"
}

# Make zsh the login shell. On macOS the Homebrew zsh must be listed in
# /etc/shells first; on Arch /bin/zsh is already a valid shell.
set_default_shell() {
    target_shell=$(command -v zsh) || {
        _warn "zsh not found; leaving the default shell unchanged."
        return 0
    }
    case "${SHELL:-}" in
    */zsh)
        return 0
        ;;
    esac
    _process "Setting zsh as the default shell"
    if [ "$OS" = "macos" ] && ! grep -qxF "$target_shell" /etc/shells 2> /dev/null; then
        printf '%s\n' "$target_shell" | run sudo tee -a /etc/shells > /dev/null
    fi
    run chsh -s "$target_shell"
    _success "Default shell set to zsh"
}

# Link the dotfiles into $HOME. The root installer owns the Stow package lists.
link_dotfiles() {
    _process "Linking dotfiles with Stow"
    run sh "${DOTFILES}/install.sh"
    _success "Dotfiles linked"
}

main() {
    _process "Deploying dotfiles for ${OS}"
    install_packages
    install_mise_runtimes
    set_default_shell
    link_dotfiles
    _complete "Deployment complete" \
        "Platform" "$OS" \
        "Dotfiles" "$(_tilde "$DOTFILES")"
}

main "$@"
