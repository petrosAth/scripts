# deploy/linux/ — AGENTS.md

Arch package provisioning for the cross-platform deployer. See `Home/Scripts/AGENTS.md` for repository-wide rules and `deploy/common/` for the shared engine this plugs into.

> **Never run the real flow as a test.** `install.sh` runs `pacman`, `paru`, `makepkg`, `sudo`, and `systemctl`. Verify with `sh -n`, `shellcheck -s sh`, and `DRY_RUN=1 sh install.sh`, which prints every command instead of running it. This is POSIX `sh`, not Bash — probe with `sh`, not `bash`.

## Design

A thin **adapter over data**. `install.sh` holds the mechanics; `pacman.txt` and `aur.txt` hold the package set. This replaced a legacy `eval`-driven Bash engine (`install.sh` + a 75-entry `actions.sh` registry) that carried ten verified traps; the rewrite exists specifically to not rebuild them. Key inherited rules:

- `set -eu` at the top; real exit-status checks, never `[[ $? ]]`.
- No `eval`, no indirect-expansion dispatch, no numeric-count key convention.
- paru is built in a `mktemp -d`, **never** in `$HOME` — and the `cd` into it stays inside a subshell so it cannot leak (the old engine's `cd` side effects corrupted every later action).
- Linking is **not** done here. GNU Stow owns it (repo-root `install.sh`); there is no symlink stage to resurrect.
- Arch only. There is no distro/interface/profile matrix — that machinery existed solely for a headless ArchWSL target that was dropped, and it had zero CLI-only content anyway.

## The adapter (`install.sh`)

Sources `../common/lib.sh` for `_process`/`_success`, `run` (honours `DRY_RUN`), and `read_list` (strips comments and blanks from a list file). Four stages, in order: `update_system` → `install_pacman_packages` → `install_aur_packages` (which bootstraps paru first) → `enable_services` (`gdm`, `libvirtd`).

`install_pacman_packages` feeds the list to `pacman -S --needed --noconfirm -` on stdin; `install_aur_packages` expands the list into `paru` arguments. Both use `--needed` so re-runs are cheap and idempotent.

## The lists

`actions_list` entry (`pacman.txt:4-90`)-style categories are preserved as section comments — they map cleanly onto the macOS `Brewfile` sections and are depended on by `fontconfig/AGENTS.md` for the font set. One package per line; `#` comments (whole-line and trailing) and blanks are ignored by `read_list`.

**Boundary with mise:** mise (`mise/.config/mise/config.toml`) owns language runtimes (`go`, `java`, `lua`, `node`, `python`, `ruby`, `neovim`) and most CLI tools (`tmux`, `zoxide`, `oh-my-posh`, `bat`, `fzf`, `pandoc`, `sqlite`, `fastfetch`, `eza`, `lazygit`, `delta` — Git's pager, `claude`, `codex`, `tree-sitter`, `gh`, `tmuxinator` — a `gem:` backend entry on mise's `ruby`). Python is intentionally also installed here so boot and non-interactive scripts have `/usr/bin/python3`; mise remains the interactive development runtime. `ripgrep`, `fd`, `mkcert`, `jq`, `docker`, and `docker-compose` are OS-managed. No other mise tool belongs in these lists. `php`/`composer` remain normal package entries (official repo / Brewfile).

## Verification

```sh
sh -n install.sh
shellcheck -s sh install.sh          # if installed
grep -hv '^#' pacman.txt aur.txt | sed '/^[[:space:]]*$/d' | sort | uniq -d
DRY_RUN=1 sh install.sh
```

Inspect this submodule's status separately from the parent dotfiles repo.
