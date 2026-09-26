# deploy/common/ — AGENTS.md

The shared, platform-neutral engine for the deployer. POSIX `sh`. See `Home/Scripts/AGENTS.md` for repository-wide rules.

> Verify with `sh -n`, `shellcheck -s sh`, and `sh deploy.sh --simulate`. Never run the real flow — it installs packages and changes the login shell. Bootstrap cannot simulate because it runs before the repository exists.

## Files

- **`bootstrap.sh`** — the curl-able entry point. It runs **before the repo exists**, so it must stay self-contained: no `source`, no dependency on `lib.sh` or anything else in the tree. On Arch, prerequisites are installed in the same `pacman -Syu --needed` transaction as the full upgrade; `curl` already arrives through `base` → `pacman`. Flow: `detect_os` → prerequisites → SSH gate (`gh auth login -p ssh -s admin:public_key`, which generates or picks the key and uploads it; no manual `ssh-keygen`/`gh ssh-key add`) → remove gh's generated `config.yml` → clone `~/dotfiles` with submodules → `exec` `deploy.sh`. Must be invoked as `sh -c "$(curl …)"`, never piped, so stdin stays on the tty for `gh auth login` and prompts.
- **`deploy.sh`** — the on-disk driver, run after the clone with `lib.sh` available. Flow: OS adapter → `mise install` → default shell → repo-root `install.sh` (Stow). Computes `DOTFILES` as four levels up from this directory (`deploy/common` → `deploy` → `Scripts` → `Home` → repo root).
- **`lib.sh`** — sourced helpers: `_process`/`_success`/`_warn`/`_error`/`die` (tty-guarded colors, all to stderr), `detect_os` (arch | macos), `platform_name`, shared `-n`/`--simulate` parsing, `run`, `run_installer`, `confirm` (bounded retries, defaults to no at EOF — never an unbounded `read`), and `read_list` (strips comments and blanks from a package list; requires a readable regular file and propagates filtering read failures, but a list that is empty or all-comments after filtering is a valid, non-failing result — callers must check for that themselves if an empty list changes what they do).

## Load-bearing invariants

- **The SSH probe matches text, not exit code.** `ssh -T git@github.com` returns exit 1 even on success; `github_ssh_ok` greps for `successfully authenticated`. Do not "fix" it to test `$?`.
- **Never `git init` in `$HOME`.** `clone_dotfiles` clones into a self-contained directory and refuses to touch a non-repo path that already exists.
- **Every state-changing command goes through `run`** so simulation prints the full sequence. Nested installers go through `run_installer`, which executes their own `--simulate` mode. Keep it that way when adding steps.
- **Only gh's generated regular `~/.config/gh/config.yml` is removed.** `gh auth login` creates it and it would block Stow. A symlink (the repository's own config) and `hosts.yml` are never touched.
- **A failed `mise install` warns, never aborts.** `install_mise_runtimes` must not block the Stow step; source-build libraries live in `linux/pacman.txt`.
- Status output goes to **stderr**; stdout is reserved for real command output (e.g. `read_list` piped into a package manager).
