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

**Do not add here:** anything mise already provisions (`mise/.config/mise/config.toml`) — language runtimes (`go`, `java`, `lua`, `node`, `ruby`, `neovim`) and CLI tools (`tmux`, `zoxide`, `oh-my-posh`, `bat`, `fzf`, `pandoc`, `sqlite`, `fastfetch`, `eza`, `lazygit`, `claude`, `codex`, `tree-sitter`, `gh`, `tmuxinator`). Python is intentionally installed by both pacman and mise: `/usr/bin/python3` is for boot and non-interactive scripts, while mise supplies the interactive development runtime. `ripgrep`, `fd`, `mkcert`, `jq`, `docker`, `docker-compose`, and `php`/`composer` are normal official-repository packages rather than mise tools.

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
