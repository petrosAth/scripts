# deploy/common/ — AGENTS.md

The shared, platform-neutral engine for the deployer. POSIX `sh`. See `Home/Scripts/AGENTS.md` for repository-wide rules.

> Verify with `sh -n`, `shellcheck -s sh`, and `sh deploy.sh --simulate`. Never run the real flow — it installs packages and changes the login shell. Bootstrap cannot simulate because it runs before the repository exists.

## Files

- **`bootstrap.sh`** — the curl-able entry point. It runs **before the repo exists**, so it must stay self-contained: no `source`, no dependency on `lib.sh` or anything else in the tree. Flow: `detect_os` → prerequisites → SSH gate → clone `~/dotfiles` with submodules → `exec` `deploy.sh`. Must be invoked as `sh -c "$(curl …)"`, never piped, so stdin stays on the tty for `gh auth login` and prompts.
- **`deploy.sh`** — the on-disk driver, run after the clone with `lib.sh` available. Flow: OS adapter → `mise install` → default shell → repo-root `install.sh` (Stow). Computes `DOTFILES` as four levels up from this directory (`deploy/common` → `deploy` → `Scripts` → `Home` → repo root).
- **`lib.sh`** — sourced helpers: `_process`/`_success`/`_warn`/`_error`/`die` (tty-guarded colors, all to stderr), `detect_os` (arch | macos), `platform_name`, shared `-n`/`--simulate` parsing, `run`, `run_installer`, `confirm` (bounded retries, defaults to no at EOF — never an unbounded `read`), and `read_list` (strips comments and blanks from a package list).

## Load-bearing invariants

- **The SSH probe matches text, not exit code.** `ssh -T git@github.com` returns exit 1 even on success; `github_ssh_ok` greps for `successfully authenticated`. Do not "fix" it to test `$?`.
- **Never `git init` in `$HOME`.** `clone_dotfiles` clones into a self-contained directory and refuses to touch a non-repo path that already exists.
- **Every state-changing command goes through `run`** so simulation prints the full sequence. Nested installers go through `run_installer`, which executes their own `--simulate` mode. Keep it that way when adding steps.
- Status output goes to **stderr**; stdout is reserved for real command output (e.g. `read_list` piped into a package manager).
