#!/usr/bin/env sh
set -eu

# Arch Linux package provisioning. Called by ../common/deploy.sh after the repo
# is cloned; not a standalone bootstrap (see ../common/bootstrap.sh). Installs
# official-repo packages, enables the system services the KDE Plasma desktop and
# virtualization/container tools need, then bootstraps paru for AUR packages.
#
# Never linking here: GNU Stow owns that (repo-root install.sh).

SCRIPT_DIR=$(
    unset CDPATH
    cd "$(dirname "$0")" && pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/../common/lib.sh"

parse_args "$@"

# Interruptions stop deployment, including while an AUR command is running.
trap 'exit 130' INT
trap 'exit 143' TERM

PACMAN_LIST="${SCRIPT_DIR}/pacman.txt"
AUR_LIST="${SCRIPT_DIR}/aur.txt"

# makepkg refuses to run as root, and running the whole adapter as root would
# also misdirect every `sudo` call. Fail fast instead of deep inside paru's
# bootstrap.
require_non_root() {
    [ "$(id -u)" -ne 0 ] \
        || die "Run this installer as your normal user, not root; it calls sudo where needed and makepkg refuses to run as root."
}

# Turn on colored pacman output; a no-op once Color is already uncommented.
# bootstrap.sh has already run the full `pacman -Syu`.
enable_pacman_color() {
    run sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
}

# Install every official-repo package in one transaction. --needed skips already
# installed packages so re-runs are cheap. The list is captured into a variable
# first (rather than piped) so a missing file's die() actually aborts the
# script under `set -e`, and so simulation prints the real package names
# instead of a bare stdin redirection.
install_pacman_packages() {
    _process "Installing official-repo packages"
    packages=$(read_list "$PACMAN_LIST")
    # shellcheck disable=SC2086
    run sudo pacman -S --needed --noconfirm $packages
    _success "Official-repo packages installed"
}

# Build paru from the AUR into a throwaway directory (never $HOME: trap T6),
# but only when it is not already on PATH. The build directory is cleaned up
# on any exit path, including a failed makepkg.
bootstrap_paru() {
    if command -v paru > /dev/null 2>&1; then
        return 0
    fi
    _process "Bootstrapping paru (AUR helper)"
    if [ "$SIMULATE" -eq 1 ]; then
        printf 'SIMULATE: git clone https://aur.archlinux.org/paru.git <tmp>/paru\n' >&2
        printf 'SIMULATE: (cd <tmp>/paru && makepkg -si --noconfirm)\n' >&2
        _success "paru installed"
        return 0
    fi
    # Explicit status checks: the caller runs this under `if !`, where set -e
    # is off. makepkg must run from the build directory and refuses root.
    build_dir=$(mktemp -d) || return 1
    trap 'rm -rf "$build_dir"' EXIT
    if git clone https://aur.archlinux.org/paru.git "${build_dir}/paru" \
        && (cd "${build_dir}/paru" && makepkg -si --noconfirm); then
        status=0
    else
        status=1
    fi
    rm -rf "$build_dir"
    trap - EXIT
    [ "$status" -eq 0 ] || return 1
    _success "paru installed"
}

# Install AUR packages, skipping paru entirely (bootstrap included) when the
# list has nothing in it. paru resolves official-repo dependencies itself and
# keeps its interactive PKGBUILD review (no --noconfirm). An AUR failure warns
# instead of aborting, so mise and Stow still run; rerunning the deployer is safe.
install_aur_packages() {
    packages=$(read_list "$AUR_LIST")
    if [ -z "$packages" ]; then
        _process "No AUR packages listed; skipping paru"
        return 0
    fi
    rerun="sh ~/dotfiles/Home/Scripts/deploy/common/deploy.sh"
    if ! bootstrap_paru; then
        _warn "paru bootstrap failed; skipping AUR packages. Rerun: ${rerun}"
        return 0
    fi
    _process "Installing AUR packages"
    # shellcheck disable=SC2086
    if ! run paru -S --needed $packages; then
        _warn "Some AUR packages failed to install. Rerun: ${rerun}"
        return 0
    fi
    _success "AUR packages installed"
}

# Enable Plasma Login Manager, bluetooth, libvirt (socket-activated) and Docker,
# and add the user to the docker and libvirt groups (effective next login).
# Why each choice is made this way is recorded in AGENTS.md; `id -un` because
# $USER can be unset under set -u.
enable_services() {
    _process "Enabling system services"
    run sudo systemctl enable plasmalogin.service
    run sudo systemctl enable --now bluetooth.service
    run sudo systemctl enable --now libvirtd.socket
    run sudo systemctl enable --now docker.socket
    run sudo usermod -aG docker "$(id -un)"
    run sudo usermod -aG libvirt "$(id -un)"
    # The default NAT network is what dnsmasq and iptables are installed for.
    # libvirtd defines it on first start, so a fresh machine can race this;
    # warn rather than abort, since everything else is already in place.
    run sudo virsh net-autostart default \
        || _warn "Could not autostart libvirt's default network; run 'sudo virsh net-autostart default' once libvirtd has started."
    _success "System services enabled"
}

main() {
    require_non_root
    enable_pacman_color
    install_pacman_packages
    enable_services
    install_aur_packages
}

main "$@"
