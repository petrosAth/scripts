# macOS deployment

`install.sh` provisions a fresh Mac: Xcode Command Line Tools → Homebrew → `brew bundle` against `Brewfile`. It is invoked by `../common/deploy.sh`, which the curl-able `../common/bootstrap.sh` hands off to; you rarely run it directly.

## What Homebrew installs

`Brewfile` carries the shared CLI formulae and the GUI casks that mirror the curated Arch set. Deliberately **not** in the Brewfile — all provisioned by mise (`mise/.config/mise/config.toml`) instead:

- **Language runtimes** — `go`, `java`, `lua`, `node`, `python`, `neovim`. `php`/`composer` are Brewfile formulae, not mise runtimes.
- **CLI tools** — `tmux`, `zoxide`, `oh-my-posh`, `bat`, `fzf`, `pandoc`, `ripgrep`, `sqlite`, `fastfetch`, `fd`, `eza`, `lazygit`, `claude`, `codex`, `docker-cli`, `docker-compose`, `tree-sitter`, `mkcert`, `jq`.

The AWS CLI is Homebrew-managed (`brew "awscli"`), not a mise tool. The `docker-desktop` cask still provides the container engine; mise's `docker-cli`/`docker-compose` are just the client tools.

## Manual installs (no Homebrew cask)

These Linux packages have no maintained macOS cask. Install them by hand if you need them on macOS:

- **FileZilla** — download from filezilla-project.org (or use `brew install --cask filezillapro` if licensed).
- **Deskflow** — download from deskflow.org.
- **Avidemux** — download from avidemux.sourceforge.net.
- **Remmina** — no macOS build; use Microsoft's Remote Desktop (`windows-app` cask) or another RDP client. Verify the cask name before adding it to the Brewfile.

## Not applicable on macOS

GNOME, Wayland, PipeWire, `gdm`, GParted, Ventoy, virt-manager, CoreCtrl, Conky, foot, fontconfig, and `wl-clipboard` are Linux-only. `pbcopy` is built in, and `zsh/.config/zsh/60-commands.zsh:ywd` already branches to it. Noto CJK and emoji ship with macOS, so the Linux nine-font set reduces to the three Nerd Font casks.

## Verification

```sh
sh -n install.sh
brew bundle check --file=Brewfile
```

`brew services` and `chsh` are handled by `../common/deploy.sh`, not here. Never add `brew bundle cleanup` to an install path.
