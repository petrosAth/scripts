# deploy/linux/ — AGENTS.md

The **Arch Linux bootstrap deployer**: the pre-Stow, do-everything installer for a fresh machine. See `Home/Scripts/AGENTS.md` for repository-wide rules.

**Status: legacy, pending replacement.** GNU Stow now owns linking (repo-root `install.sh` → `stow --restow --no-folding`), which makes this script's `create_symlinks` stage obsolete. `deploy/mac/` exists and is **empty** — this directory is the raw material for a unified Linux+macOS deployer. Read this file as the brief for that refactor: what the design got right, what Stow retired, and which traps must not be rebuilt.

> **Never run this script, or any command extracted from it.** It runs `pacman`/`paru`/`makepkg`/`sudo`/`systemctl`/`chsh`, and `git reset --hard` directly over `$HOME`. Verification is `bash -n`, `shellcheck`, and isolated single-mechanic probes in a throwaway `bash -c` — nothing else.
>
> **Use `/opt/homebrew/bin/bash` (5.x) for any probe.** macOS `/bin/bash` is 3.2 and lacks `declare -A`, `local -n`, and `${var,,}` — findings from it are wrong.

## Two files, one shell

`install.sh` is the **engine**; `actions.sh` is the **data**. Both are Bash, not POSIX `sh`. There is no `set -euo pipefail`, and `execute` runs every registry value through `eval` **in the current shell** — so `cd` and variable side effects leak across actions.

`deploy()` (`install.sh:220-237`), called unconditionally at `:240`:

```
get_distro → get_interface → [guard] → update_system → install_git_github_cli
  → clone_dotfiles → source ${SCRIPT_DIR}/actions.sh → actions_sequence → create_symlinks
```

`SCRIPT_DIR` (`:25`) points inside the repo that `clone_dotfiles` has just cloned — the source at `:232` is correctly sequenced after it, but is also the single point of failure (see T2). The documented entry point (`:14`) is `bash -c "$(curl …)"`, **not** `curl … | bash`: the command-substitution form keeps stdin on the tty, which every `read -p` and `gh auth login` depends on.

## The action DSL

An `actions_list` entry (`actions.sh:4-90`) must **exactly match** a `declare -A` block name (`:95-532`) — a mismatch is silent, the action simply vanishes. Currently 75 blocks, 56 active, 19 commented out in both places (1:1, no orphans).

| Key                            | Value                            | Consumed by                      | Numeric count? |
| ------------------------------ | -------------------------------- | -------------------------------- | -------------- |
| `interface`                    | `cli` \| `gui` \| `both`         | gate at `install.sh:176`, `:208` | No             |
| `message_process`              | free text                        | `_process`, `:178`               | No             |
| `message_success`              | free text                        | `_success`, `:187`               | No             |
| `pre`                          | shell command(s)                 | phase 1                          | Yes            |
| `dir`                          | **exactly** `mkdir -p <path>`    | phase 2                          | Yes            |
| `<distro>` — `arch`, `archWSL` | shell command(s)                 | gate at `:174` + phase 3         | Yes            |
| `post`                         | shell command(s)                 | phase 4                          | Yes            |
| `link`                         | **exactly** `ln -fs <src> <dst>` | `create_symlinks` only           | Yes            |

Two separate passes over the whole registry: `actions_sequence` runs `pre → dir → <distro> → post` (`:165`), then `create_symlinks` runs `link` (`:199`). So every install completes before any link. Order within a pass is `actions_list` order.

**Numeric-count convention** — if a key's value matches `^[0-9]+$` it is a count `N`, and `<key>1`…`<key>N` are eval'd in order (`:147-154`):

```bash
[arch]="5"
[arch1]="cd ${HOME}"
[arch5]="cd .. && rm -rf paru"
```

Applies to the five keys that reach `execute` (`pre`, `dir`, `<distro>`, `post`, `link`) and **not** to `interface`/`message_*`, which are read directly. Gaps eval an empty string silently; a wrong `N` truncates or overruns with no error.

**Live key census:** `arch` ×91, `message_process` ×75, `interface` ×75, `archWSL` ×32, `post` ×6. **`pre`, `dir`, `link`, and `message_success` are used zero times** — that machinery is dead code, and `create_symlinks` is a no-op that still prints "dotfiles have been linked."

## How the dispatcher reads a key

Two idioms, both indirect expansion. Understanding them explains every shape constraint in the table above.

```bash
# A — presence test + execution (install.sh:143-145). No splitting; missing key → "".
local execute=${action}[${command}]      # literal string "install_paru[arch]"
[[ ${!execute} ]] && eval "${!execute}"

# B — the announcement path (install.sh:170-171, :203-204). Word-SPLIT, positional.
local action_dir=(${action}[dir])        # array: ([0]="install_x[dir]")
local action_dir_array=(${!action_dir})  # ("mkdir" "-p" "/path")  ← unquoted = split
```

Idiom B hard-codes the command's argv layout: `install.sh:181` reads `[2]` for the directory, `:210` reads `[2]` and `[3]` for link source and destination. Hence `mkdir -p <path>` (a bare `mkdir <path>` leaves `[2]` empty) and `ln -fs <src> <dst>` with the flags fused into one word. Paths may contain neither whitespace nor glob characters. **Only the message breaks** if the shape is wrong — `execute` re-reads the key via idiom A and eval's the whole string.

Idiom B is also why a blanket "quote everything" cleanup would break this file: the splitting is load-bearing.

`${HOME}` and `${DIR}` inside the double-quoted values are expanded at **source time** (`install.sh:232`), frozen into the arrays — not at `eval` time. Sourcing `actions.sh` standalone yields broken paths, because `DIR` is defined only in `install.sh:23`.

## Known traps — all verified under bash 5.3

Ranked by damage if carried into the successor. Do not build on any of these assumptions.

| #   | Trap                                                                     | Anchor                                     | Consequence                                                                                                                                                                                                                                                                                                        |
| --- | ------------------------------------------------------------------------ | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| T1  | `git init` + `git reset --hard origin/$branch` **directly over `$HOME`** | `install.sh:126,130`                       | Destroys any pre-existing `~/.zshrc`, `~/.gitconfig`, `~/.config/**` with no backup or prompt; leaves a permanent `$HOME/.git` that captures every later `git` command run outside another repo. Architecturally incompatible with Stow, which needs the repo in a _separate_ directory. **Discard, do not port.** |
| T2  | `source` failure is silent                                               | `install.sh:25,232`                        | `SCRIPT_DIR` assumes the `master` layout (`$HOME/Scripts/…`). On the stow-era branches the submodule is at `Home/Scripts`, so the path misses. With no `set -e` the script continues, `actions_list` is unset, zero actions run — and every success banner still prints.                                           |
| T3  | `selection=${selection,,}` lowercases the distro                         | `install.sh:57`                            | `DISTRO` becomes `archwsl`, but the keys are `[archWSL]` and the case arms are `archWSL)`. **Every ArchWSL path is dead**: no system update, no git/gh, zero packages — followed by "All packages have been installed". Any mixed-case distro name added to `VALID_DISTRO` inherits this bug.                      |
| T4  | No `set -euo pipefail`                                                   | `install.sh:1`                             | Nothing can fail loudly. Compounds every other trap.                                                                                                                                                                                                                                                               |
| T5  | `[[ $? ]]` is **always true**                                            | `:96,114,120,134,186,193,217,242`          | `$?` expands to a non-empty string (`"1"`, `"137"`), and `[[ str ]]` is a non-empty test. All ten success gates are decorative.                                                                                                                                                                                    |
| T6  | `eval` in the current shell → persistent `cd`                            | `install.sh:153,157`; `actions.sh:114-124` | If paru's `git clone` fails, `cd paru` short-circuits and `[arch5]`'s `cd .. && rm -rf paru` runs from `$HOME` — targeting `/home/paru`. Remove `[arch5]` and cwd stays wrong for all 50+ following actions.                                                                                                       |
| T7  | `create_symlinks` is a lying no-op                                       | `install.sh:196-218`                       | Zero `[link]` keys exist; the loop matches nothing and prints success anyway. This is exactly the gap Stow now fills.                                                                                                                                                                                              |
| T8  | `read` loop spins forever at EOF                                         | `install.sh:52-54`                         | `read` returns non-zero and leaves `selection` empty, so the condition never becomes true. Safe under the documented `bash -c "$(curl …)"`; pegs a core under `curl … \| bash`. No retry cap.                                                                                                                      |
| T9  | Post-input guard is vacuous                                              | `install.sh:226`                           | Reads `valid_array`/`selection`, which are `local -n` namerefs scoped to `get_user_input`. Both empty ⇒ `[[ "  " =~ "  " ]]` ⇒ always true.                                                                                                                                                                        |
| T10 | `ssh -T git@github.com` **exits 1 on success**                           | `install.sh:119`                           | GitHub never grants shell access. Fixing T5 naively here turns a working setup into a reported failure — special-case it.                                                                                                                                                                                          |

Smaller, still real: `[[ ${INTERFACE} == ${!action_interface} ]]` (`:176`, `:208`) has an unquoted RHS, so the value is a **glob pattern**, not a literal. `command_number` (`:152`) is missing `local`. `GITHUB_EMAIL` (`:19`) is never read. `install_virt_manager` (`actions.sh:390`) is the only `pacman -S` without `--needed`. `install_tmuxinator`'s `[archWSL]` (`:342`) both omits `sudo` and uses `pacman` for an AUR-only package. Nothing anywhere passes `--noconfirm`, so the "one-liner bootstrap" is interactive from start to finish.

**`README.md` is stale in ~20 places and must not be trusted over the code.** Worst offenders: it canonises the broken `[[ $? ]] && _success` idiom as the reference pattern (`:24`); it documents `pre`/`dir`/`link` as working features (none has ever run); its `[dir]` example omits `-p`; it says `action_list` where the code says `actions_list`; its multi-command example has unbalanced quotes (`:97,99`) and still references `yay` after the migration to paru.

## Recipes

**Add an action.** Append the name to the right category in `actions_list`, then add a `declare -A` block of the same name in the matching section. Give it `[interface]`, `[message_process]`, and one key per supported distro. Multi-step installs use the numeric count. Keep font packages in the Fonts section — `fontconfig/AGENTS.md` in the parent repo depends on them.

**Add a distribution.** Four steps, not the two the README claims: (1) add the name to `VALID_DISTRO` (`install.sh:27`); (2) add a `case` arm to `update_system` (`:85`) **and** `install_git_github_cli` (`:102`); (3) add a `[<distro>]` key to every action you want installed. **Use an all-lowercase name** — anything else is dead on arrival via T3.

**Coverage check.** 25 active actions are `both`, 31 are `gui`, and **zero are `cli`** — the CLI tier has never had any content, so choosing CLI installs only the 25 `both` actions. `install_lazygit` (`actions.sh:315`) and `install_btop` (`:362`) are the only `both` actions missing an `[archWSL]` key; latent today because of T3.

## Carrying this forward to `deploy/mac/`

**Keep:** the four bootstrap stages Stow cannot do (system update → package-manager bootstrap → git/gh/ssh auth → repo + submodule clone), and the category organisation of `actions_list`, which reads well and maps onto Brewfile sections.

**Discard:** `create_symlinks` and the `link`/`dir`/`pre` schema (provably dead, Stow's job); `clone_dotfiles`' `git init` in `$HOME` (T1) — clone to a separate directory and stow out of it; the `eval`-on-indirect-expansion engine and the `[arch]="5"` counter convention; the `arch`/`archWSL` duplication (~90% identical — collapse to one target plus a headless flag).

**Must be abstracted for macOS:** `sudo pacman`/`paru` → `brew`/`brew install --cask` (Homebrew refuses to run as root, so `sudo` cannot stay baked into the data); `systemctl enable` → `brew services`, though the only live Linux services are `gdm` and `libvirtd`, neither of which has a macOS analogue; fonts map ~9→3, since macOS ships CJK and emoji; `chsh` is a no-op unless targeting Homebrew's zsh, which must first be added to `/etc/shells`.

**On macOS, a Brewfile replaces this registry outright** — `brew bundle` natively provides multi-step (`postinstall:`), services (`restart_service:`), conditionals (`if OS.mac?`), casks, and Mac App Store apps, plus `check` and `dump`, which this engine cannot do at all. There is no `pacman` entry type, so it cannot subsume the Arch side. Never wire `brew bundle cleanup` into an install path.

**The CLI/GUI split does not survive the port.** It exists to serve headless ArchWSL vs desktop Arch; macOS is always GUI. Make it a Linux-only filter, or generalise it to platform-neutral profile tags.

**Check `mise` before adding anything.** `mise/.config/mise/config.toml` already provisions `neovim` and `node`, which makes `install_bob` (`actions.sh:132`) and `install_nodejs_npm` (`:185`) redundant and conflicting. Moving `go`, `jdk`, `python`, `php`, `lazygit`, and `tmuxinator` into mise shrinks the mac/linux delta at zero abstraction cost — the highest-leverage single move in the refactor.

## Verification

```sh
/opt/homebrew/bin/bash -n install.sh actions.sh   # both currently parse clean
shellcheck install.sh actions.sh                  # if installed
```

Confirm `actions_list` and the `declare -A` names still correspond, and re-run a probe rather than trusting a claim about Bash semantics. Inspect this submodule's status separately from the parent repo. Never execute the deployment flow.
