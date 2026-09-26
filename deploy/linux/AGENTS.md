# deploy/linux/ — AGENTS.md

Arch package provisioning for the cross-platform deployer. See `Home/Scripts/AGENTS.md` for repository-wide rules and `deploy/common/` for the shared engine this plugs into.

> **Never run the real flow as a test.** `install.sh` runs `pacman`, `paru`, `makepkg`, `sudo`, and `systemctl`. Verify with `sh -n`, `shellcheck -s sh`, and `sh install.sh --simulate`, which prints every command instead of running it. This is POSIX `sh`, not Bash — probe with `sh`, not `bash`.

## Design

A thin **adapter over data**. `install.sh` holds the mechanics; `pacman.txt` and `aur.txt` hold the package set. This replaced a legacy `eval`-driven Bash engine (`install.sh` + a 75-entry `actions.sh` registry) that carried ten verified traps; the rewrite exists specifically to not rebuild them. Key inherited rules:

- `set -eu` at the top; real exit-status checks, never `[[ $? ]]`.
- No `eval`, no indirect-expansion dispatch, no numeric-count key convention.
- paru is built in a `mktemp -d`, **never** in `$HOME` — and the `cd` into it stays inside a subshell so it cannot leak (the old engine's `cd` side effects corrupted every later action).
- Linking is **not** done here. GNU Stow owns it (repo-root `install.sh`); there is no symlink stage to resurrect.
- Arch only. There is no distro/interface/profile matrix — that machinery existed solely for a headless ArchWSL target that was dropped, and it had zero CLI-only content anyway.

## The adapter (`install.sh`)

Sources `../common/lib.sh` for argument parsing, `_process`/`_success`, `run`, and `read_list` (strips comments and blanks from a list file). The `require_non_root` preflight check runs before any of the four stages, in order: `enable_pacman_color` → `install_pacman_packages` → `enable_services` (`plasmalogin`, `bluetooth`, `libvirtd.socket`, `docker.socket`, the `docker` and `libvirt` groups, and libvirt's default NAT network) → `install_aur_packages` (which bootstraps paru first, skipped entirely when `aur.txt` has no entries).

**AUR is last and non-fatal.** An AUR build is the likeliest thing to fail, so it runs after the desktop and services are enabled, and `install_aur_packages` warns (with the deploy rerun command) instead of aborting, so `deploy.sh` still reaches mise and Stow. `bootstrap_paru` is called under `if !`, where `set -e` is off, so it checks `mktemp`, `git clone` and `makepkg` explicitly and returns 1 on failure; keep those checks if you edit it. Installer-wide INT/TERM handlers exit with 130/143 so interruption stops deployment, including during the later Paru invocation. The temporary-build cleanup trap handles EXIT only; clear only EXIT after normal cleanup, leaving INT/TERM active.

Both `install_pacman_packages` and `install_aur_packages` capture `read_list`'s output into a `packages` variable and expand it unquoted (`$packages`) as `pacman`/`paru` arguments — never piped. A variable assignment from a failing command substitution aborts under `set -e`, so a missing, non-regular, unreadable, or read-failing list is fatal; piping into a command that ignores stdin (as `run` does under `--simulate`) previously masked both the failure and the actual package names. `install_aur_packages` checks for an empty list before bootstrapping paru at all, so a machine with nothing in `aur.txt` never builds it. Both use `--needed` so re-runs are cheap and idempotent.

AUR installation uses `paru -S --needed` without `--noconfirm`, which would skip interactive PKGBUILD review. On a fresh installation it uses Paru's defaults because Stow links the user configuration afterwards. Paru's own `makepkg -si --noconfirm` bootstrap has no automatic review step.

`enable_services` turns on Plasma Login Manager (`plasmalogin.service`) unconditionally. This is a KDE Plasma install; there is no other desktop path.

Three of its choices are deliberate and easy to "correct" back into bugs:

- **`libvirtd.socket`, not `libvirtd.service`.** On-demand socket activation avoids running the daemon continuously and pulls `virtlogd.socket`/`virtlockd.socket` in by itself. Upstream libvirt is migrating to the modular daemons (`virtqemud`, `virtnetworkd`, `virtstoraged`) and means to drop the monolithic one, but ArchWiki still documents `libvirtd` as the primary path, so that migration is intentionally deferred.
- **`bluetooth.service` is enabled explicitly.** `bluez-utils` does not depend on `bluez`; the daemon only arrives transitively through `plasma-meta` → `bluedevil` → `bluez-qt` → `bluez`, and nothing else would start it.
- **`id -un`, not `$USER`.** `$USER` is unset in a non-login environment and would abort the whole installer under `set -u`.

`virsh net-autostart default` is allowed to fail with a warning: libvirtd defines that network on first start, so a fresh machine can race it, and everything else is already in place by then.

**The `libvirt` group is what makes virt-manager passwordless**, and it is the whole mechanism — do not add `libvirtd.conf` edits or a custom polkit rule on top of it. The `libvirt` package ships `/usr/share/polkit-1/rules.d/50-libvirt.rules`, which returns `polkit.Result.YES` for `org.libvirt.unix.manage` to any member of that group. Without the group a `wheel` user still gets in, but via `50-default.rules`' `auth_admin_keep` — a password prompt.

`/etc/libvirt/libvirtd.conf` is deliberately untouched. Under socket activation `libvirtd.socket` creates the socket itself with `SocketMode=0666`, so that file's `unix_sock_group` and `unix_sock_rw_perms` never apply; editing it would only add a `.pacnew` to reconcile on every upgrade for no effect.

Both the `docker` and `libvirt` group additions take effect at the next login.

## The lists

`actions_list`-style categories are preserved as section comments — they map cleanly onto the macOS `Brewfile` sections and are depended on by `fontconfig/AGENTS.md` for the font set. One package per line; `#` comments (whole-line and trailing) and blanks are ignored by `read_list`.

**Boundary with mise:** mise (`mise/.config/mise/config.toml`) owns language runtimes (`go`, `java`, `lua`, `node`, `python`, `ruby`, `rust`, `neovim`) and most CLI tools (`tmux`, `zoxide`, `oh-my-posh`, `bat`, `fzf`, `pandoc`, `sqlite`, `fastfetch`, `eza`, `lazygit`, `delta` — Git's pager, `claude`, `codex`, `tree-sitter`, `gh`, `tmuxinator` — a `gem:` backend entry on mise's `ruby`, `git-surgeon` — a `cargo:` backend entry on mise's `rust`, `yazi`). Python is intentionally also installed here so boot and non-interactive scripts have `/usr/bin/python3`; mise remains the interactive development runtime. `ripgrep`, `fd`, `mkcert`, `jq`, `7zip`, `ffmpeg`, `poppler`, `resvg`, `imagemagick`, and `docker` are official-repository packages. Docker Compose and Buildx come from the official `docker-compose` and `docker-buildx` packages; Docker Desktop is deliberately not installed (the rootful engine via `docker.socket` is the only Docker). No other mise tool belongs in these lists. The `mise source-build dependencies` section of `pacman.txt` is not an exception: it holds system libraries that mise's `php` (verzly/mise-php, default build groups) and `ruby` (`libyaml` for psych) source builds link against. Packages already guaranteed by `base`/`base-devel` are deliberately left out. `php`/`composer` remain normal package entries (official repo / Brewfile).

**Do not re-add transitive packages.** `plasma-meta` already pulls `plasma-login-manager`, `plasma-nm`, `kwallet-pam` and `xdg-desktop-portal-kde`; `base` provides `iproute2` and pulls `curl` through `pacman`; `plasma-meta` pulls `flatpak` through `flatpak-kcm`; `docker` depends on `nftables`; `breeze-plymouth` pulls `plymouth`. All were removed from `pacman.txt` precisely because listing them implies they are separately required. `iptables` is correct as written — it now `Provides`/`Replaces` `iptables-nft`. The explicitly listed `kgamma`, `plymouth-kcm`, `union`, and `wacomtablet` are optional dependencies of `plasma-meta`, so keep them. `freerdp` is an optional dependency of Remmina and supplies the chosen RDP backend.

`kde-applications-meta` is the **full** KDE application set: 12 sub-metas resolving to roughly 194 packages and several GB, including `kde-games-meta`, `kde-education-meta` and `kdevelop-meta`. It replaced the `kde-applications` _group_ because a group is expanded once at install time and never revisited, whereas a tracked meta package picks up later additions on upgrade. It is not a smaller install. To actually shrink it, drop to individual sub-metas or named applications.

## Routine updates

For a normal full system update, run:

```sh
paru -Syu
```

Use this occasional forced database refresh only when needed; it re-downloads all repository databases and is unnecessary for normal updates:

```sh
paru -Syyu
```

Never perform a database-only refresh before upgrading: that partial-update pattern can leave Arch inconsistent. Review [Arch News](https://archlinux.org/news/) for manual intervention before the upgrade and check `.pacnew` notices afterwards.

## Verification

```sh
sh -n install.sh
shellcheck -s sh install.sh          # if installed
grep -hv '^#' pacman.txt aur.txt | sed -e 's/#.*//' -e '/^[[:space:]]*$/d' | sort | uniq -d
sh install.sh --simulate
```

Inspect this submodule's status separately from the parent dotfiles repo.
