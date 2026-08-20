# macOS deployment

`install.sh` provisions a fresh Mac: Xcode Command Line Tools → Homebrew → `brew bundle` against `Brewfile`. It is invoked by `../common/deploy.sh`, which the curl-able `../common/bootstrap.sh` hands off to; you rarely run it directly.

## What Homebrew installs

`Brewfile` carries the shared CLI formulae and the GUI casks that mirror the curated Arch set. Deliberately **not** in the Brewfile — all provisioned by mise (`mise/.config/mise/config.toml`) instead:

- **Language runtimes** — `go`, `java`, `lua`, `node`, `python`, `ruby`, `rust`, `neovim`. Python is intentionally also a Brewfile formula so boot and non-interactive scripts have a system `python3`; `php`/`composer` are Brewfile formulae, not mise runtimes.
- **CLI tools** — `tmux`, `zoxide`, `oh-my-posh`, `bat`, `fzf`, `pandoc`, `sqlite`, `fastfetch`, `eza`, `lazygit`, `delta` (Git's pager, via `core.pager`), `claude`, `codex`, `tree-sitter`, `gh`, `tmuxinator` (a `gem:` backend entry on mise's `ruby`), `git-surgeon` (a `cargo:` backend entry on mise's `rust`), `yazi`. `ripgrep`, `fd`, `mkcert`, `jq`, `sevenzip`, `ffmpeg-full`, `poppler`, `resvg`, and `imagemagick-full` are Brewfile formulae instead.

Yazi's full FFmpeg and ImageMagick variants are keg-only. Their Brewfile entries use `link: :overwrite`; on a fresh installation Homebrew Bundle adds `--force` for the keg-only formulae and links commands such as `ffmpeg`, `ffprobe`, and `magick` into the Homebrew prefix. Keep this metadata on the formula entries rather than adding a separate post-install command.

The AWS CLI, Docker CLI, and Docker Compose are Homebrew-managed (`brew "awscli"`, `brew "docker"`, `brew "docker-compose"`), not mise tools. The `docker-desktop` cask still provides the container engine and GUI; the Homebrew formulae are the day-to-day client and compose binaries.

The Stats menu-bar system monitor is an intentional Homebrew-only GUI application (`cask "stats"`); it has no entry in the Arch package lists.

## Routine updates

On an existing macOS installation, run Homebrew as the account that owns its prefix, never with `sudo brew`:

```sh
brew update && brew upgrade && brew cleanup
```

`brew cleanup` removes outdated downloads and package versions. It is distinct from `brew bundle cleanup`, which uninstalls formulae and casks that are not declared in the Brewfile and must not be added to the install path.

## Manual installs (no Homebrew cask)

These Linux packages have no maintained macOS cask. Install them by hand if you need them on macOS:

- **FileZilla** — download from filezilla-project.org (or use `brew install --cask filezillapro` if licensed).
- **Deskflow** — download from deskflow.org.
- **Avidemux** — download from avidemux.sourceforge.net.
- **Remmina** — no macOS build; use Microsoft's Remote Desktop (`windows-app` cask) or another RDP client. Verify the cask name before adding it to the Brewfile.

## Not applicable on macOS

GNOME, Wayland, PipeWire, `gdm`, GParted, Ventoy, virt-manager, Conky, foot, fontconfig, and `wl-clipboard` are Linux-only. `pbcopy` is built in, and `zsh/.config/zsh/60-commands.zsh:ywd` already branches to it. Noto CJK and emoji ship with macOS, so the Linux nine-font set reduces to the three Nerd Font casks.

## Verification

```sh
sh -n install.sh
sh install.sh --simulate
brew bundle check --file=Brewfile
```

`brew services` and `chsh` are handled by `../common/deploy.sh`, not here. Never add `brew bundle cleanup` to an install path.
