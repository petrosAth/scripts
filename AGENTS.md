# Scripts repository

This is an independent Git repository nested inside the dotfiles `Home` package. It contains standalone utilities and deployment scripts for Linux and Windows; do not treat its history or working tree as part of the parent commit.

## Linux deployment architecture

- `deploy/linux/install.sh` is Bash, not POSIX `sh`. It collects normalized distribution and interface input, clones the dotfiles, sources `actions.sh`, executes registered actions, and creates configured links.
- `deploy/linux/actions.sh` owns `actions_list` and one associative array per registered action. An entry in `actions_list` must exactly match its `declare -A` variable.
- Each action declares its supported interface and distribution keys. Multi-command values use a numeric count plus consecutively numbered keys.
- Keep process and success messages on the action that owns the operation. Font packages required by Fontconfig also belong in the Fonts section here.
- These scripts run package managers, `sudo`, Git operations, and other machine-changing commands. Do not execute the deployment flow as a test.

## Editing rules

- Quote paths and expansions unless Bash syntax deliberately requires word splitting.
- Preserve the current success-message helpers and action ordering.
- Update `deploy/linux/README.md` when changing the action schema rather than documenting a one-off package addition.

## Verification

```sh
bash -n deploy/linux/install.sh deploy/linux/actions.sh
```

Run `shellcheck` as an additional check when it is installed. Inspect this repository's status separately from the parent dotfiles repository.
