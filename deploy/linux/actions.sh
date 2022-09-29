#!/bin/bash

#|=< Array of actions to be taken by the auto installation script >===========|#
actions_list=(
#|-< Core >-------------------------------------------------------------------|#
    "install_base_devel"
    "install_reflector"
    "install_paru"
#|-< Cosmetics >--------------------------------------------------------------|#
    "install_papirus_icon_theme"
    # "install_conky"
#|-< Development >------------------------------------------------------------|#
    "install_python_pip"
    "install_jdk_openjdk"
    "install_go"
    "install_nodejs_npm"
    "install_mono"
    "install_dotnet"
    "install_powershell_bin"
    "install_unityhub"
#|-< Utilities >--------------------------------------------------------------|#
    "install_python_pynvim"      # Neovim dependancy
    "install_xclip"              # Neovim clipboard sync
    "install_unzip"              # Neovim LSP Installer dependancy
    "install_fd"                 # Neovim plugin telescope dependancy
    "install_ripgrep"            # Neovim plugin telescope dependancy
    "install_fzf"
    "install_tree"
    "install_zsh"
    "install_exa"
    "install_kitty"
    "install_lazygit"
    "install_timeshift"
    "install_trash_cli"
    "install_tmux"
    "install_xplr"
    "install_bat"
    "install_neofetch"
    "install_btop"
    "install_electrum"
    "install_etcher"
    "install_virt_manager"
#|-< Remote and Cloud >-------------------------------------------------------|#
    "install_filezilla"
    "install_bitwarden"
    "install_synergy_git"
    "install_nextcloud_client"
    "install_remmina"
    "install_wakeonlan"          # Used by remmina to wake remote desktops
#|-< Fonts >------------------------------------------------------------------|#
    "install_inter_font"
    "install_ibm_plex"
    "install_chrome_os_fonts"
    "install_twitter_emoji_font"
    "install_nerd_fonts_jetbrains_mono"
#|-< Editing >----------------------------------------------------------------|#
    "install_onlyoffice"
    "install_blender"
    "install_inkscape"
    "install_handbrake"
    "install_avidemux_qt"
    "install_audacity"
#|-< Web & Chat >-------------------------------------------------------------|#
    "install_firefox"
    "install_thunderbird"
    "install_jdownloader2"
#|-< Multimedia >-------------------------------------------------------------|#
    "install_vlc"
)
#|============================================================================|#

#|=< Installation commands >==================================================|#
#|-< Core >-------------------------------------------------------------------|#
declare -A install_base_devel=(
    [interface]="both"
    [message_process]="* Installing base-devel package group "
    [arch]="sudo pacman -S --needed base-devel"
    [archWSL]="sudo pacman -S --needed base-devel"
)
declare -A install_reflector=(
    [interface]="both"
    [message_process]="* Installing Reflector. A Pacman mirror list manager "
    [arch]="4"
    [arch1]="sudo pacman -S --needed reflector"
    [arch2]="echo -e '--save /etc/pacman.d/mirrorlist\n--latest 10\n--sort rate' | sudo tee /etc/xdg/reflector/reflector.conf > /dev/null"
    [arch3]="sudo systemctl enable --now reflector.service"
    [arch4]="sudo systemctl enable --now reflector.timer"
)
declare -A install_paru=(
    [interface]="both"
    [message_process]="* Installing Paru AUR helper "
    [arch]="5"
    [arch1]="cd ${HOME}"
    [arch2]="sudo pacman -S --needed git base-devel"
    [arch3]="git clone https://aur.archlinux.org/paru.git"
    [arch4]="cd paru && makepkg -si"
    [arch5]="cd .. && rm -rf paru"
    [archWSL]="5"
    [archWSL1]="cd ${HOME}"
    [archWSL2]="sudo pacman -S --needed git base-devel"
    [archWSL3]="git clone https://aur.archlinux.org/paru.git"
    [archWSL4]="cd paru && makepkg -si"
    [archWSL5]="cd .. && rm -rf paru"
)
#|-< Cosmetics >--------------------------------------------------------------|#
declare -A install_papirus_icon_theme=(
    [interface]="gui"
    [message_process]="* Installing Papirus icon theme for Linux "
    [arch]="3"
    [arch1]="sudo pacman -S --needed papirus-icon-theme"
    [arch2]="wget -qO- https://git.io/papirus-folders-install | sh"
    [arch3]="papirus-folders -C nordic --theme Papirus-Dark"
)
declare -A install_conky=(
    [interface]="gui"
    [message_process]="* Installing Conky. a free, light-weight system monitor "
    [arch]="paru -S --needed conky-lua-archers-git"
)
#|-< Development >------------------------------------------------------------|#
declare -A install_python_pip=(
    [interface]="both"
    [message_process]="* Installing Python and pip package manager "
    [arch]="sudo pacman -S --needed python python-pip"
    [archWSL]="sudo pacman -S --needed python python-pip"
)
declare -A install_jdk_openjdk=(
    [interface]="both"
    [message_process]="* Installing OpenJDK Java development kit "
    [arch]="sudo pacman -S --needed jdk-openjdk"
    [archWSL]="sudo pacman -S --needed jdk-openjdk"
)
declare -A install_go=(
    [interface]="both"
    [message_process]="* Installing GO language "
    [arch]="sudo pacman -S --needed go"
    [archWSL]="sudo pacman -S --needed go"
)
declare -A install_nodejs_npm=(
    [interface]="both"
    [message_process]="* Installing Node.js and npm package manager "
    [arch]="sudo pacman -S --needed nodejs-lts-gallium npm"
    [archWSL]="sudo pacman -S --needed nodejs-lts-gallium npm"
)
declare -A install_mono=(
    [interface]="both"
    [message_process]="* Installing mono. Free implementation of the .NET platform including runtime and compiler "
    [arch]="sudo pacman -S --needed mono mono-msbuild mono-msbuild-sdkresolver"
    [archWSL]="sudo pacman -S --needed mono mono-msbuild mono-msbuild-sdkresolver"
)
declare -A install_dotnet=(
    [interface]="both"
    [message_process]="* Installing the .NET Core runtime and SDK "
    [arch]="sudo pacman -S --needed dotnet-runtime dotnet-sdk"
    [archWSL]="sudo pacman -S --needed dotnet-runtime dotnet-sdk"
)
declare -A install_powershell_bin=(
    [interface]="both"
    [message_process]="* Installing PowerShell "
    [arch]="paru -S --needed powershell-bin"
    [archWSL]="paru -S --needed powershell-bin"
    [post]="2"
    [post1]="pwsh -Command Install-Module -Name PowerShellGet  -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
    [post2]="pwsh -Command Install-Module -Name PSReadLine     -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
)
declare -A install_unityhub=(
    [interface]="gui"
    [message_process]="* Installing Unity Hub, a standalone application that streamlines the way you find, download, and manage your Unity Projects and installations "
    [arch]="paru -S --needed unityhub"
)
#|-< Utilities >--------------------------------------------------------------|#
declare -A install_python_pynvim=(
    [interface]="both"
    [message_process]="* Installing Pynvim "
    [arch]="sudo pacman -S --needed python-pynvim"
    [archWSL]="sudo pacman -S --needed python-pynvim"
)
declare -A install_xclip=(
    [interface]="gui"
    [message_process]="* Installing xclip "
    [arch]="sudo pacman -S --needed xclip"
)
declare -A install_unzip=(
    [interface]="both"
    [message_process]="* Installing Unzip "
    [arch]="sudo pacman -S --needed unzip"
    [archWSL]="sudo pacman -S --needed unzip"
)
declare -A install_fd=(
    [interface]="both"
    [message_process]="* Installing fd, a simple, fast and user-friendly alternative to 'find' "
    [arch]="sudo pacman -S --needed fd"
    [archWSL]="sudo pacman -S --needed fd"
)
declare -A install_ripgrep=(
    [interface]="both"
    [message_process]="* Installing ripGREP, a search tool that combines the usability of 'ag' with the raw speed of 'grep' "
    [arch]="sudo pacman -S --needed ripgrep"
    [archWSL]="sudo pacman -S --needed ripgrep"
)
declare -A install_fzf=(
    [interface]="both"
    [message_process]="* Installing fzf, a command-line fuzzy finder "
    [arch]="sudo pacman -S --needed fzf"
    [archWSL]="sudo pacman -S --needed fzf"
)
declare -A install_tree=(
    [interface]="both"
    [message_process]="* Installing Tree, a directory listing program displaying a depth indented list of files "
    [arch]="sudo pacman -S --needed tree"
    [archWSL]="sudo pacman -S --needed tree"
)
declare -A install_zsh=(
    [interface]="both"
    [message_process]="* Installing Z shell (zsh) "
    [arch]="sudo pacman -S --needed zsh"
    [archWSL]="sudo pacman -S --needed zsh"
    [post]="chsh -s /bin/zsh" # Change default shell to zsh
)
declare -A install_exa=(
    [interface]="both"
    [message_process]="* Installing exa, a modern replacement for 'ls' "
    [arch]="sudo pacman -S --needed exa"
    [archWSL]="sudo pacman -S --needed exa"
)
declare -A install_kitty=(
    [interface]="gui"
    [message_process]="* Installing kitty The fast, feature-rich, GPU based terminal emulator "
    [arch]="sudo pacman -S --needed kitty"
)
declare -A install_lazygit=(
    [interface]="both"
    [message_process]="* Installing lazygit. A simple terminal UI for git commands "
    [arch]="sudo pacman -S --needed lazygit"
)
declare -A install_timeshift=(
    [interface]="gui"
    [message_process]="* Installing Timeshift. A system restore utility for Linux "
    [arch]="paru -S --needed timeshift timeshift-autosnap"
    [post]="sudo systemctl enable cronie.service"
)
declare -A install_grub_btrfs=(
    [interface]="gui"
    [message_process]="* Installing grub-btrfs. Include btrfs snapshots in GRUB boot options "
    [arch]="sudo pacman -S --needed grub-btrfs"
    [post]="sudo sed -i 's/#GRUB_BTRFS_TITLE_FORMAT=("date" "snapshot" "type" "description")/GRUB_BTRFS_TITLE_FORMAT=("date" "type" "description")/' /etc/default/grub-btrfs/config" # Add color to pacman output
    [post]="sudo systemctl enable grub-btrfs.path"
)
declare -A install_trash_cli=(
    [interface]="both"
    [message_process]="* Installing trash-cli. Command line interface to the freedesktop.org trashcan "
    [arch]="sudo pacman -S --needed trash-cli"
    [archWSL]="sudo pacman -S --needed trash-cli"
)
declare -A install_tmux=(
    [interface]="both"
    [message_process]="* Installing terminal multiplexer tmux "
    [arch]="sudo pacman -S --needed tmux"
    [archWSL]="sudo pacman -S --needed tmux"
)
declare -A install_xplr=(
    [interface]="both"
    [message_process]="* Installing xplr, a hackable, minimal, fast TUI file explorer "
    [arch]="sudo pacman -S --needed xplr"
    [archWSL]="sudo pacman -S --needed xplr"
)
declare -A install_bat=(
    [interface]="both"
    [message_process]="* Installing Bat, a cat(1) clone with syntax highlighting and Git integration "
    [arch]="sudo pacman -S --needed bat"
    [archWSL]="sudo pacman -S --needed bat"
)
declare -A install_neofetch=(
    [interface]="both"
    [message_process]="* Installing system information tool Neofetch "
    [arch]="sudo pacman -S --needed neofetch"
    [archWSL]="sudo pacman -S --needed neofetch"
)
declare -A install_btop=(
    [interface]="both"
    [message_process]="* Installing BTOP++, a monitor of resources "
    [arch]="sudo pacman -S --needed btop"
)
declare -A install_electrum=(
    [interface]="gui"
    [message_process]="* Installing Electrum Bitcoin wallet "
    [arch]="sudo pacman -S --needed electrum"
)
declare -A install_etcher=(
    [interface]="gui"
    [message_process]="* Installing Etcher OS image flasher "
    [arch]="paru -S --needed balena-etcher"
)
declare -A install_virt_manager=(
    [interface]="gui"
    [message_process]="* Installing Virtual Machine Manager "
    [arch]="sudo pacman -S qemu-desktop virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat dmidecode edk2-ovmf"
    [post]="sudo systemctl enable --now libvirtd"
)
#|-< Remote and Cloud >-------------------------------------------------------|#
declare -A install_filezilla=(
    [interface]="gui"
    [message_process]="* Installing FileZilla "
    [arch]="sudo pacman -S --needed filezilla"
)
declare -A install_bitwarden=(
    [interface]="gui"
    [message_process]="* Installing Bitwarden, the most trusted open source password manager for business "
    [arch]="sudo pacman -S --needed bitwarden"
)
declare -A install_synergy_git=(
    [interface]="gui"
    [message_process]="* Installing Synergy "
    [pre]="cd ${HOME}/.config/Synergy && git checkout linux"
    [arch]="paru -S --needed synergy-git"
)
declare -A install_nextcloud_client=(
    [interface]="gui"
    [message_process]="* Installing Nextcloud client "
    [arch]="sudo pacman -S --needed nextcloud-client"
)
declare -A install_remmina=(
    [interface]="gui"
    [message_process]="* Installing Remmina the GTK+ Remote Desktop Client "
    [arch]="sudo pacman -S --needed remmina freerdp"
)
declare -A install_wakeonlan=(
    [interface]="gui"
    [message_process]="* Installing wakeonlan. Utility for waking up computers using UDP Wake-on-Lan packets "
    [arch]="paru -S --needed wakeonlan"
)
#|-< Fonts >------------------------------------------------------------------|#
declare -A install_inter_font=(
    [interface]="gui"
    [message_process]="* Installing Inter font family "
    [arch]="sudo pacman -S --needed inter-font"
)
declare -A install_ibm_plex=(
    [interface]="gui"
    [message_process]="* Installing IBM Plex font family "
    [arch]="sudo pacman -S --needed ttf-ibm-plex"
)
declare -A install_chrome_os_fonts=(
    [interface]="gui"
    [message_process]="* Installing Chrome OS core fonts "
    [arch]="sudo pacman -S --needed ttf-croscore"
)
declare -A install_twitter_emoji_font=(
    [interface]="gui"
    [message_process]="* Installing Twitter Emoji font "
    [arch]="paru -S --needed ttf-twemoji"
)
declare -A install_nerd_fonts_jetbrains_mono=(
    [interface]="gui"
    [message_process]="* Installing Nerd Fonts JetBrains Mono "
    [dir]="mkdir -p ${HOME}/.local/share/fonts/TTF"
    [arch]="17"
    [arch1]="cd ${HOME}/.local/share/fonts/TTF"
    [arch2]="curl -fLo 'JetBrains Mono Bold Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Bold/complete/JetBrains%20Mono%20Bold%20Nerd%20Font%20Complete.ttf"
    [arch3]="curl -fLo 'JetBrains Mono Bold Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/BoldItalic/complete/JetBrains%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete.ttf"
    [arch4]="curl -fLo 'JetBrains Mono ExtraBold Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/ExtraBold/complete/JetBrains%20Mono%20ExtraBold%20Nerd%20Font%20Complete.ttf"
    [arch5]="curl -fLo 'JetBrains Mono ExtraBold Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/ExtraBoldItalic/complete/JetBrains%20Mono%20ExtraBold%20Italic%20Nerd%20Font%20Complete.ttf"
    [arch6]="curl -fLo 'JetBrains Mono ExtraLight Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/ExtraLight/complete/JetBrains%20Mono%20ExtraLight%20Nerd%20Font%20Complete.ttf"
    [arch7]="curl -fLo 'JetBrains Mono ExtraLight Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/ExtraLightItalic/complete/JetBrains%20Mono%20ExtraLight%20Italic%20Nerd%20Font%20Complete.ttf"
    [arch8]="curl -fLo 'JetBrains Mono Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Italic/complete/JetBrains%20Mono%20Italic%20Nerd%20Font%20Complete.ttf"
    [arch9]="curl -fLo 'JetBrains Mono Light Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Light/complete/JetBrains%20Mono%20Light%20Nerd%20Font%20Complete.ttf"
    [arch10]="curl -fLo 'JetBrains Mono Light Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/LightItalic/complete/JetBrains%20Mono%20Light%20Italic%20Nerd%20Font%20Complete.ttf"
    [arch11]="curl -fLo 'JetBrains Mono Medium Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Medium/complete/JetBrains%20Mono%20Medium%20Nerd%20Font%20Complete.ttf"
    [arch12]="curl -fLo 'JetBrains Mono Medium Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/MediumItalic/complete/JetBrains%20Mono%20Medium%20Italic%20Nerd%20Font%20Complete.ttf"
    [arch13]="curl -fLo 'JetBrains Mono Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf"
    [arch14]="curl -fLo 'JetBrains Mono SemiBold Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/SemiBold/complete/JetBrains%20Mono%20SemiBold%20Nerd%20Font%20Complete.ttf"
    [arch15]="curl -fLo 'JetBrains Mono SemiBold Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/SemiBoldItalic/complete/JetBrains%20Mono%20SemiBold%20Italic%20Nerd%20Font%20Complete.ttf"
    [arch16]="curl -fLo 'JetBrains Mono Thin Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Thin/complete/JetBrains%20Mono%20Thin%20Nerd%20Font%20Complete.ttf"
    [arch17]="curl -fLo 'JetBrains Mono Thin Italic Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/ThinItalic/complete/JetBrains%20Mono%20Thin%20Italic%20Nerd%20Font%20Complete.ttf"
    [post]="cd ${HOME}"
)
#|-< Editing >----------------------------------------------------------------|#
declare -A install_onlyoffice=(
    [interface]="gui"
    [message_process]="* Installing OnlyOffice. Open-source office suite that combines text, spreadsheet and presentation editors "
    [arch]="paru -S --needed onlyoffice-bin"
)
declare -A install_blender=(
    [interface]="gui"
    [message_process]="* Installing Blender. A fully integrated 3D graphics creation suite "
    [arch]="sudo pacman -S --needed blender"
)
declare -A install_inkscape=(
    [interface]="gui"
    [message_process]="* Installing Inkscape. Professional vector graphics editor "
    [arch]="sudo pacman -S --needed inkscape"
)
declare -A install_handbrake=(
    [interface]="gui"
    [message_process]="* Installing Handbrake "
    [arch]="sudo pacman -S --needed handbrake"
)
declare -A install_avidemux_qt=(
    [interface]="gui"
    [message_process]="* Installing Avidemux "
    [arch]="sudo pacman -S --needed avidemux-qt"
)
declare -A install_audacity=(
    [interface]="gui"
    [message_process]="* Installing Audacity "
    [arch]="sudo pacman -S --needed audacity"
)
#|-< Web & Chat >-------------------------------------------------------------|#
declare -A install_firefox=(
    [interface]="gui"
    [message_process]="* Installing Firefox "
    [arch]="sudo pacman -S --needed firefox"
)
declare -A install_thunderbird=(
    [interface]="gui"
    [message_process]="* Installing Thunderbird, a free email application that's easy to set up and customize "
    [arch]="sudo pacman -S --needed thunderbird"
)
declare -A install_jdownloader2=(
    [interface]="gui"
    [message_process]="* Installing Jdownloader "
    [arch]="paru -S --needed jdownloader2"
)
#|-< Multimedia >-------------------------------------------------------------|#
declare -A install_vlc=(
    [interface]="gui"
    [message_process]="* Installing VLC "
    [arch]="sudo pacman -S --needed vlc"
)
#|============================================================================|#
