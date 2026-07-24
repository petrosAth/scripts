# Scripts repository

This is an independent Git repository nested inside the dotfiles `Home` package. It contains standalone utilities and deployment scripts for Linux and Windows; do not treat its history or working tree as part of the parent commit.

## Linux deployment architecture

`deploy/linux/` is the Arch bootstrap deployer — a Bash engine (`install.sh`) driven by an action registry (`actions.sh`). It is legacy pending a cross-platform replacement, and it carries several verified traps. **Read `deploy/linux/AGENTS.md` before touching it**; that file is authoritative for the action schema, the dispatcher mechanics, and the refactor brief.

These scripts run package managers, `sudo`, Git operations, and other machine-changing commands. Do not execute the deployment flow as a test.

## Editing rules

- Quote paths and expansions unless Bash syntax deliberately requires word splitting.
- Preserve the current success-message helpers and action ordering.
- Update `deploy/linux/README.md` when changing the action schema rather than documenting a one-off package addition.

## Verification

```sh
bash -n deploy/linux/install.sh deploy/linux/actions.sh
```

Run `shellcheck` as an additional check when it is installed. Inspect this repository's status separately from the parent dotfiles repository.
