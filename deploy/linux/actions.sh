#!/bin/bash

# Array of actions to be taken by the auto installation script
actions_list=(
# Package Managers
    "install_yay"
# Development
    "install_base_devel"
    "install_git"
    "install_github_cli"
    "install_go"
    "install_nodejs"
    "install_npm"
    "install_python_pip"
    "install_zsh"
    "install_powershell_bin"
    "install_unityhub_beta"
    "install_filezilla"
    "install_neovim_git" # Neovim or Neovim plugin dependancy
    "install_python_pynvim"      # Neovim or Neovim plugin dependancy
    "install_code_minimap"   # Neovim or Neovim plugin dependancy
# Remote and Cloud
    "install_openssh"
    "install_bitwarden"
    "install_nextcloud_client"
# Utilities
    "install_unzip"              # Neovim or Neovim plugin dependancy
    "install_fd"                 # Neovim or Neovim plugin dependancy
    "install_ripgrep"            # Neovim or Neovim plugin dependancy
    "install_alacritty_git"
    "install_starship"
    "install_wget"
    "install_oh_my_posh"
    "install_solaar"
    "install_kdeconnect"
# Fonts
    "install_fonts_firacode"
# Editing
    "install_blender"
    "install_handbrake"
    "install_avidemux_qt"
    "install_audacity"
# Web & Chat
    "install_uget"
    "install_firefox"
    "install_thunderbird"
# Entertainment
    "install_vlc"
)

# Package managers -------------------------------------------------------------
declare -A install_yay=(
    [interface]="both"
    [message_process]="* Installing yay "
    [arch]="4"
    [arch1]="sudo pacman -S --needed git base-devel"
    [arch2]="git clone https://aur.archlinux.org/yay-bin.git"
    [arch3]="cd yay-bin && makepkg -si"
    [arch4]="cd .. && rm -rf yay-bin"
    [endeavour]="sudo pacman -S --needed yay"
    [manjaro]="sudo pacman -S --needed yay"
)
# Development ------------------------------------------------------------------
declare -A install_base_devel=(
    [interface]="both"
    [message_process]="* Installing Package group base-devel "
    [arch]="sudo pacman -S --needed base-devel"
    [endeavour]="sudo pacman -S --needed base-devel"
    [manjaro]="sudo pacman -S --needed base-devel"
)
declare -A install_git=(
    [interface]="both"
    [message_process]="* Installing Git "
    [arch]="sudo pacman -S --needed git"
    [endeavour]="sudo pacman -S --needed git"
    [manjaro]="sudo pacman -S --needed git"
    [link]="ln -fs ${DIR}/git/.gitconfig ${HOME}/.gitconfig"
)
declare -A install_github_cli=(
    [interface]="both"
    [message_process]="* Installing GitHub CLI "
    [dir]="mkdir -p ${HOME}/.config/gh"
    [arch]="sudo pacman -S --needed github-cli"
    [endeavour]="sudo pacman -S --needed github-cli"
    [manjaro]="sudo pacman -S --needed github-cli"
    [link]="ln -fs ${DIR}/gh/config.yml ${HOME}/.config/gh/config.yml"
)
declare -A install_go=(
    [interface]="both"
    [message_process]="* Installing GO language "
    [arch]="sudo pacman -S --needed go"
    [endeavour]="sudo pacman -S --needed go"
    [manjaro]="sudo pacman -S --needed go"
)
declare -A install_nodejs=(
    [interface]="both"
    [message_process]="* Installing Node.js "
    [arch]="sudo pacman -S --needed nodejs"
    [endeavour]="sudo pacman -S --needed nodejs"
    [manjaro]="sudo pacman -S --needed nodejs"
)
declare -A install_npm=(
    [interface]="both"
    [message_process]="* Installing Node.js package manager (npm) "
    [arch]="sudo pacman -S --needed npm"
    [endeavour]="sudo pacman -S --needed npm"
    [manjaro]="sudo pacman -S --needed npm"
)
declare -A install_python_pip=(
    [interface]="both"
    [message_process]="* Installing Python package manager (pip) "
    [arch]="sudo pacman -S --needed python-pip"
    [endeavour]="sudo pacman -S --needed python-pip"
    [manjaro]="sudo pacman -S --needed python-pip"
)
declare -A install_zsh=(
    [interface]="both"
    [message_process]="* Installing Z shell (zsh) "
    [arch]="sudo pacman -S --needed zsh"
    [endeavour]="sudo pacman -S --needed zsh"
    [manjaro]="sudo pacman -S --needed zsh"
    [link]="ln -fs ${DIR}/zsh/.zshrc ${HOME}/.zshrc"
    [post]="chsh -s /bin/zsh" # Change default shell to zsh
)
declare -A install_powershell_bin=(
    [interface]="both"
    [message_process]="* Installing PowerShell "
    [dir]="mkdir -p ${HOME}/.config/powershell"
    [arch]="yay -S --needed powershell"
    [endeavour]="yay -S --needed powershell"
    [manjaro]="yay -S --needed powershell"
    [link]="ln -fs ${DIR}/powershell/Microsoft.PowerShell_profile.ps1 ${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1"
    [post]="2"
    [post1]="pwsh -Command Install-Module -Name PowerShellGet  -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
    [post2]="pwsh -Command Install-Module -Name PSReadLine     -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
)
declare -A install_unityhub_beta=(
    [interface]="gui"
    [message_process]="* Installing Unity Hub beta "
    [arch]="yay -S --needed unityhub-beta"
    [endeavour]="yay -S --needed unityhub-beta"
    [manjaro]="yay -S --needed unityhub-beta"
)
declare -A install_filezilla=(
    [interface]="gui"
    [message_process]="* Installing FileZilla "
    [arch]="sudo pacman -S --needed filezilla"
    [endeavour]="sudo pacman -S --needed filezilla"
    [manjaro]="sudo pacman -S --needed filezilla"
)
declare -A install_neovim_git=(
    [interface]="both"
    [message_process]="* Installing Neovim (pulling from git) "
    [dir]="mkdir -p ${HOME}/.config"
    [arch]="yay -S --needed neovim-git"
    [endeavour]="yay -S --needed neovim-git"
    [manjaro]="yay -S --needed neovim-git"
    [link]="ln -fs ${DIR}/nvim ${HOME}/.config/nvim"
)
declare -A install_python_pynvim=(
    [interface]="both"
    [message_process]="* Installing Pynvim "
    [arch]="sudo pacman -S --needed python-pynvim"
    [endeavour]="sudo pacman -S --needed python-pynvim"
    [manjaro]="sudo pacman -S --needed python-pynvim"
)
declare -A install_code_minimap=(
    [interface]="both"
    [message_process]="* Installing code-minimap "
    [arch]="yay -S --needed code-minimap"
    [endeavour]="yay -S --needed code-minimap"
    [manjaro]="yay -S --needed code-minimap"
)
# Remote and Cloud -------------------------------------------------------------
declare -A install_openssh=(
    [interface]="both"
    [message_process]="* Installing OpenSSH "
    [arch]="sudo pacman -S --needed openssh"
    [endeavour]="sudo pacman -S --needed openssh"
    [manjaro]="sudo pacman -S --needed openssh"
)
declare -A install_bitwarden=(
    [interface]="gui"
    [message_process]="* Installing Bitwarden "
    [arch]="sudo pacman -S --needed bitwarden"
    [endeavour]="sudo pacman -S --needed bitwarden"
    [manjaro]="sudo pacman -S --needed bitwarden"
)
declare -A install_nextcloud_client=(
    [interface]="gui"
    [message_process]="* Installing Nextcloud client "
    [arch]="sudo pacman -S --needed nextcloud-client"
    [endeavour]="sudo pacman -S --needed nextcloud-client"
    [manjaro]="sudo pacman -S --needed nextcloud-client"
)
# Utilities --------------------------------------------------------------------
declare -A install_unzip=(
    [interface]="both"
    [message_process]="* Installing Unzip "
    [arch]="sudo pacman -S --needed unzip"
    [endeavour]="sudo pacman -S --needed unzip"
    [manjaro]="sudo pacman -S --needed unzip"
)
declare -A install_fd=(
    [interface]="both"
    [message_process]="* Installing fd "
    [arch]="sudo pacman -S --needed fd"
    [endeavour]="sudo pacman -S --needed fd"
    [manjaro]="sudo pacman -S --needed fd"
)
declare -A install_ripgrep=(
    [interface]="both"
    [message_process]="* Installing ripGREP "
    [arch]="sudo pacman -S --needed ripgrep"
    [endeavour]="sudo pacman -S --needed ripgrep"
    [manjaro]="sudo pacman -S --needed ripgrep"
)
declare -A install_alacritty=(
    [interface]="gui"
    [message_process]="* Installing Alacritty (pulling from git) "
    [dir]="mkdir -p ${HOME}/.config/alacritty"
    [arch]="yay -S --needed alacritty-git"
    [endeavour]="yay -S --needed alacritty-git"
    [manjaro]="yay -S --needed alacritty-git"
    [link]="ln -fs ${DIR}/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml"
)
declare -A install_starship=(
    [interface]="both"
    [message_process]="* Installing Starship "
    [arch]="sudo pacman -S --needed starship"
    [endeavour]="sudo pacman -S --needed starship"
    [manjaro]="sudo pacman -S --needed starship"
)
declare -A install_wget=(
    [interface]="both"
    [message_process]="* Installing Wget "
    [arch]="sudo pacman -S --needed wget"
    [endeavour]="sudo pacman -S --needed wget"
    [manjaro]="sudo pacman -S --needed wget"
)
declare -A install_oh_my_posh=(
    [interface]="both"
    [message_process]="* Installing Oh My Posh "
    [arch]="2"
    [arch1]="sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh"
    [arch2]="sudo chmod +x /usr/local/bin/oh-my-posh"
    [endeavour]="2"
    [endeavour1]="sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh"
    [endeavour2]="sudo chmod +x /usr/local/bin/oh-my-posh"
    [manjaro]="2"
    [manjaro1]="sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh"
    [manjaro2]="sudo chmod +x /usr/local/bin/oh-my-posh"
)
declare -A install_solaar=(
    [interface]="gui"
    [message_process]="* Installing Solaar "
    [arch]="sudo pacman -S --needed solaar"
    [endeavour]="sudo pacman -S --needed solaar"
    [manjaro]="sudo pacman -S --needed solaar"
)
declare -A install_kdeconnect=(
    [interface]="gui"
    [message_process]="* Installing KDE Connect "
    [arch]="sudo pacman -S --needed kdeconnect"
    [endeavour]="sudo pacman -S --needed kdeconnect"
    [manjaro]="sudo pacman -S --needed kdeconnect"
)
# Fonts
declare -A install_fonts_firacode=(
    [interface]="gui"
    [message_process]="* Installing Fonts: Fira Code Regular "
    [dir]="mkdir -p ${HOME}/.local/share/fonts/ttf/FiraCode"
    [arch]="3"
    [arch1]="cd ${HOME}/.local/share/fonts/ttf/FiraCode"
    [arch2]="curl -fLo 'Fira Code Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"            =
    [arch3]="curl -fLo 'Fira Code Regular Nerd Font Complete Mono.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"=
    [endeavour]="3"
    [endeavour1]="cd ${HOME}/.local/share/fonts/ttf/FiraCode"
    [endeavour2]="curl -fLo 'Fira Code Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"
    [endeavour3]="curl -fLo 'Fira Code Regular Nerd Font Complete Mono.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
    [manjaro]="3"
    [manjaro1]="cd ${HOME}/.local/share/fonts/ttf/FiraCode"
    [manjaro2]="curl -fLo 'Fira Code Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"            =
    [manjaro3]="curl -fLo 'Fira Code Regular Nerd Font Complete Mono.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"=
    [post]="cd ${HOME}"
)
# Editing ----------------------------------------------------------------------
declare -A install_blender=(
    [interface]="gui"
    [message_process]="* Installing Blender "
    [arch]="sudo pacman -S --needed blender"
    [endeavour]="sudo pacman -S --needed blender"
    [manjaro]="sudo pacman -S --needed blender"
)
declare -A install_handbrake=(
    [interface]="gui"
    [message_process]="* Installing Handbrake "
    [arch]="sudo pacman -S --needed handbrake"
    [endeavour]="sudo pacman -S --needed handbrake"
    [manjaro]="sudo pacman -S --needed handbrake"
)
declare -A install_avidemux_qt=(
    [interface]="gui"
    [message_process]="* Installing Avidemux "
    [arch]="sudo pacman -S --needed avidemux-qt"
    [endeavour]="sudo pacman -S --needed avidemux-qt"
    [manjaro]="sudo pacman -S --needed avidemux-qt"
)
declare -A install_audacity=(
    [interface]="gui"
    [message_process]="* Installing Audacity "
    [arch]="sudo pacman -S --needed audacity"
    [endeavour]="sudo pacman -S --needed audacity"
    [manjaro]="sudo pacman -S --needed audacity"
)
# Web & Chat -------------------------------------------------------------------
declare -A install_uget=(
    [interface]="gui"
    [message_process]="* Installing uGet "
    [arch]="sudo pacman -S --needed uget"
    [endeavour]="sudo pacman -S --needed uget"
    [manjaro]="sudo pacman -S --needed uget"
)
declare -A install_firefox=(
    [interface]="gui"
    [message_process]="* Installing Firefox "
    [arch]="sudo pacman -S --needed firefox"
    [endeavour]="sudo pacman -S --needed firefox"
    [manjaro]="sudo pacman -S --needed firefox"
)
declare -A install_thunderbird=(
    [interface]="gui"
    [message_process]="* Installing Thunderbird "
    [arch]="sudo pacman -S --needed thunderbird"
    [endeavour]="sudo pacman -S --needed thunderbird"
    [manjaro]="sudo pacman -S --needed thunderbird"
)
# Entertainment ----------------------------------------------------------------
declare -A install_vlc=(
    [interface]="gui"
    [message_process]="* Installing VLC "
    [arch]="sudo pacman -S --needed vlc"
    [endeavour]="sudo pacman -S --needed vlc"
    [manjaro]="sudo pacman -S --needed vlc"
)
