# Linux deployment (Arch)

Arch package provisioning for the cross-platform deployer. `install.sh` is a thin adapter driven by two plain-text package lists; it is invoked by `../common/deploy.sh`, not run directly for a normal install.

## Files

| File         | Purpose                                                         |
| ------------ | --------------------------------------------------------------- |
| `install.sh` | Adapter: update system, install lists, bootstrap paru, services |
| `pacman.txt` | Official-repo packages (`pacman -S --needed --noconfirm`)       |
| `aur.txt`    | AUR packages (`paru -S --needed`)                               |

## Editing the package set

Add or remove a line in `pacman.txt` or `aur.txt`. One package per line; `#` starts a comment (whole-line or trailing) and blank lines are ignored. Keep the section headers — they mirror the categories the deployer is organised around, and fonts in particular are depended on by `fontconfig/AGENTS.md` in the parent repo. Put a package in `aur.txt` only if it is not in the official repositories; `paru` resolves official-repo dependencies itself.

**Do not add here:** language runtimes (`go`, `java`, `lua`, `python`) — those come from mise (`mise/.config/mise/config.toml`). Nor `oh-my-posh`, which Zinit installs (`zsh/.config/zsh/20-plugins.zsh`). `php`/`composer`, `lazygit`, and `tmuxinator` **are** packages here (official repo), not mise runtimes.

## What the adapter does

1. `pacman -Syu` and enable colored pacman output.
2. Install every `pacman.txt` entry in one `--needed` transaction (stdin `-`).
3. Bootstrap `paru` from the AUR in a `mktemp -d` (never `$HOME`) if absent, then install every `aur.txt` entry.
4. `systemctl enable gdm` and `systemctl enable --now libvirtd`.

Linking is **not** done here — GNU Stow owns it (repo-root `install.sh`), run by `../common/deploy.sh` after packages are in place.

## Verification

```sh
sh -n install.sh
# Names resolve and there are no duplicates across both lists:
grep -hv '^#' pacman.txt aur.txt | sed '/^[[:space:]]*$/d' | sort | uniq -d
# Print the full command sequence without running it:
DRY_RUN=1 sh install.sh
```

Never execute the real flow as a test — it runs `pacman`, `paru`, `sudo`, and `systemctl`.
