# Scripts repository

This is an independent Git repository nested inside the dotfiles `Home` package. It contains standalone utilities and deployment scripts for Linux and Windows; do not treat its history or working tree as part of the parent commit.

## Deployment architecture

`deploy/` is the cross-platform deployer. It is POSIX `sh`, split by concern:

- `deploy/common/` — the shared engine. `bootstrap.sh` is the curl-able entry point (prerequisites → SSH gate → clone → hand off); `deploy.sh` is the on-disk driver (OS packages → mise runtimes → default shell → Stow); `lib.sh` holds the logging, OS-detection, `run`/`DRY_RUN`, `confirm`, and `read_list` helpers.
- `deploy/linux/` — Arch adapter plus `pacman.txt`/`aur.txt` package lists.
- `deploy/mac/` — macOS adapter plus a `Brewfile`.
- `deploy/windows/` — unchanged PowerShell scripts, out of scope here.

The two-stage split is deliberate: **Scripts provisions the machine; the dotfiles repo links itself** (repo-root `install.sh` → GNU Stow). Read the nearest `AGENTS.md` before editing an adapter. Runtimes and most CLI tools live in mise (`mise/.config/mise/config.toml`) — never add a package to the OS package lists if mise already provides it, except for the intentional system-Python fallback used by boot and non-interactive scripts. `ripgrep`, `fd`, `mkcert`, and `jq` are OS-managed on both platforms. The AWS CLI is an intentional Homebrew-only package.

These scripts run package managers, `sudo`, Git operations, and other machine-changing commands. Do not execute the deployment flow as a test; use `sh -n`, `shellcheck -s sh`, and `DRY_RUN=1`.

## Editing rules

- Quote paths and expansions unless Bash syntax deliberately requires word splitting.
- Preserve the current success-message helpers and action ordering.
- Update `deploy/linux/README.md` when changing the action schema rather than documenting a one-off package addition.

## Verification

```sh
bash -n deploy/linux/install.sh deploy/linux/actions.sh
```

Run `shellcheck` as an additional check when it is installed. Inspect this repository's status separately from the parent dotfiles repository.
