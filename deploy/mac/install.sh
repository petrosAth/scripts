#!/usr/bin/env sh
set -eu

# macOS package provisioning. Called by ../common/deploy.sh after the repo is
# cloned. Ensures the Xcode Command Line Tools and Homebrew are present, then
# installs everything in the Brewfile.
#
# Homebrew refuses to run under sudo, so nothing here elevates. GNU Stow owns
# linking (repo-root install.sh).

SCRIPT_DIR=$(
    unset CDPATH
    cd "$(dirname "$0")" && pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/../common/lib.sh"

BREWFILE="${SCRIPT_DIR}/Brewfile"

# The Command Line Tools provide git and the compilers Homebrew needs. The GUI
# installer is asynchronous, so prompt the user to let it finish before we go on.
ensure_clt() {
    if xcode-select -p > /dev/null 2>&1; then
        return 0
    fi
    _process "Installing Xcode Command Line Tools"
    run xcode-select --install
    _warn "Finish the Command Line Tools installer, then continue."
    confirm "Command Line Tools installed?" || die "Command Line Tools are required."
}

# Install Homebrew via the official script when brew is not already on PATH, and
# make the current shell aware of it for the rest of this run.
ensure_homebrew() {
    if command -v brew > /dev/null 2>&1; then
        return 0
    fi
    _process "Installing Homebrew"
    run /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    for prefix in /opt/homebrew /usr/local; do
        if [ -x "${prefix}/bin/brew" ]; then
            eval "$("${prefix}/bin/brew" shellenv)"
            break
        fi
    done
    _success "Homebrew installed"
}

# Install every formula, cask, tap, and font in the Brewfile. brew bundle is
# idempotent; --no-lock avoids writing a Brewfile.lock.json into the repo.
install_brewfile() {
    _process "Installing Homebrew packages from Brewfile"
    run brew bundle install --file="$BREWFILE" --no-lock
    _success "Homebrew packages installed"
}

main() {
    ensure_clt
    ensure_homebrew
    install_brewfile
}

main "$@"
