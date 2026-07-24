#!/usr/bin/env sh
set -eu

# Arch Linux package provisioning. Called by ../common/deploy.sh after the repo
# is cloned; not a standalone bootstrap (see ../common/bootstrap.sh). Installs
# official-repo packages, bootstraps and runs paru for AUR packages, and enables
# the two system services the desktop needs.
#
# Never linking here: GNU Stow owns that (repo-root install.sh).

SCRIPT_DIR=$(
    unset CDPATH
    cd "$(dirname "$0")" && pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/../common/lib.sh"

PACMAN_LIST="${SCRIPT_DIR}/pacman.txt"
AUR_LIST="${SCRIPT_DIR}/aur.txt"

# Refresh databases and upgrade the system, and turn on colored pacman output.
update_system() {
    _process "Updating system"
    run sudo pacman -Syu --noconfirm
    run sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
    _success "System updated"
}

# Install every official-repo package in one transaction. --needed skips already
# installed packages so re-runs are cheap; the list is fed on stdin via '-'.
install_pacman_packages() {
    _process "Installing official-repo packages"
    read_list "$PACMAN_LIST" | run sudo pacman -S --needed --noconfirm -
    _success "Official-repo packages installed"
}

# Build paru from the AUR into a throwaable directory (never $HOME: trap T6),
# but only when it is not already on PATH.
bootstrap_paru() {
    if command -v paru > /dev/null 2>&1; then
        return 0
    fi
    _process "Bootstrapping paru (AUR helper)"
    if [ "${DRY_RUN:-0}" = "1" ]; then
        printf 'DRY_RUN: git clone https://aur.archlinux.org/paru.git <tmp>/paru\n' >&2
        printf 'DRY_RUN: (cd <tmp>/paru && makepkg -si --noconfirm)\n' >&2
        _success "paru installed"
        return 0
    fi
    build_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "${build_dir}/paru"
    # makepkg must run from the build directory and refuses to run as root.
    (cd "${build_dir}/paru" && makepkg -si --noconfirm)
    rm -rf "$build_dir"
    _success "paru installed"
}

# Install AUR packages. paru resolves official-repo dependencies itself.
install_aur_packages() {
    bootstrap_paru
    _process "Installing AUR packages"
    # shellcheck disable=SC2046
    run paru -S --needed --noconfirm $(read_list "$AUR_LIST" | tr '\n' ' ')
    _success "AUR packages installed"
}

# Enable the display manager and the libvirt daemon. These are the only live
# services the legacy deployer enabled.
enable_services() {
    _process "Enabling system services"
    run sudo systemctl enable gdm
    run sudo systemctl enable --now libvirtd
    _success "System services enabled"
}

main() {
    update_system
    install_pacman_packages
    install_aur_packages
    enable_services
}

main "$@"
