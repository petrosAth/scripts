# Linux deployment (Arch)

Arch package provisioning for the cross-platform deployer. `install.sh` is a thin adapter driven by two plain-text package lists; it is invoked by `../common/deploy.sh`, not run directly for a normal install. Design rationale and invariants live in `AGENTS.md`.

## Files

| cd File      | Purpose                                                        |
| ------------ | -------------------------------------------------------------- |
| `install.sh` | Adapter: pacman color, official packages, services, paru + AUR |
| `pacman.txt` | Official-repo packages (`pacman -S --needed --noconfirm`)      |
| `cdaur.txt`  | AUR packages (`paru -S --needed`)                              |

## Editing the package set

Add or remove a line in `pacman.txt` or `aur.txt`. One package per line; `#` starts a comment and blank lines are ignored. Keep the section headers (`fontconfig/AGENTS.md` in the parent repo depends on the fonts section). Put a package in `aur.txt` only if it is not in the official repositories.

Do not add anything mise already provisions (`mise/.config/mise/config.toml`), and do not add packages that are already pulled in transitively (for example `plasma-meta` pulls `plasma-login-manager`, `base` pulls `curl` through `pacman`, and `breeze-plymouth` pulls `plymouth`). Docker Compose and Buildx come from the official `docker-compose` and `docker-buildx` packages.

`kde-applications-meta` is the **full** KDE application set (roughly 194 packages, several GB), not just Dolphin, Konsole and Kate.

## What the adapter does

1. Refuse to run as root, then enable colored pacman output (`bootstrap.sh` has already run `pacman -Syu`).
2. Install every `pacman.txt` entry in one `--needed` transaction.
3. Enable `plasmalogin.service`, `bluetooth.service`, `libvirtd.socket` and `docker.socket`, add you to the `docker` and `libvirt` groups (effective at next login), and autostart libvirt's default NAT network.
4. Bootstrap `paru` if absent and install every `aur.txt` entry with interactive PKGBUILD review (`paru -S --needed`). An ordinary build/install failure here only warns, so mise and Stow still run; rerun `sh ~/dotfiles/Home/Scripts/deploy/common/deploy.sh` to retry. Everything is `--needed`, so a rerun is safe.

The first AUR run uses Paru's defaults because Stow links its configuration later; deployment is interactive. Paru's own `makepkg` bootstrap has no automatic review step. Ctrl-C or TERM stops the installer rather than continuing to mise and Stow.

Linking is **not** done here; GNU Stow (repo-root `install.sh`) does it, run by `../common/deploy.sh` afterwards.

## Routine updates

```sh
paru -Syu
```

Use `paru -Syyu` only when a forced database refresh is needed. Never refresh the databases without upgrading (partial upgrades break Arch). Check [Arch News](https://archlinux.org/news/) before upgrading and `.pacnew` notices afterwards.

## Verification

```sh
sh -n install.sh
shellcheck -s sh install.sh          # if installed
# No duplicates across both lists:
grep -hv '^#' pacman.txt aur.txt | sed -e 's/#.*//' -e '/^[[:space:]]*$/d' | sort | uniq -d
# Print the full command sequence without running it:
sh install.sh --simulate
```

Never execute the real flow as a test: it runs `pacman`, `paru`, `sudo`, and `systemctl`.
