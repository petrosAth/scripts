#!/bin/bash

# Array of actions to be taken by the auto installation script
actions_list=(
# Development
    "install_base_devel"
    "install_paru"
    "install_python_pip"
    "install_jdk_openjdk"
    "install_go"
    "install_nodejs_npm"
    "install_zsh"
    "install_powershell_bin"
    "install_alacritty_git"
    "install_unityhub_beta"
    "install_filezilla"
    "install_neovim_git"                   # Neovim
    "install_python_pynvim"                # Neovim dependancy
    "install_xclip"                        # Neovim clipboard sync
    "install_unzip"                        # Neovim LSP Installer dependancy
    "install_fd"                           # Neovim plugin telescope dependancy
    "install_ripgrep"                      # Neovim plugin telescope dependancy
    "install_code_minimap"                 # Neovim plugin code minimap dependancy
# Remote and Cloud
    "install_bitwarden"
    "install_synergy_git"
    "install_nextcloud_client"
# Utilities
    "install_sxhkd"
    "install_tmux"
    "install_tdrop"
    "install_ranger"
    "install_bat"
    "install_neofetch"
    "install_glances"
    "install_electrum"
    "install_etcher"
# Cosmetics
    "install_oh_my_posh"
    "install_starship"
# Fonts
    "install_fonts_firacode"
    "install_fonts_inter"
# Editing
    "install_marktext"
    "install_blender"
    "install_handbrake"
    "install_avidemux_qt"
    "install_audacity"
# Web & Chat
    "install_firefox"
    "install_thunderbird"
    "install_jdownloader2"
# Entertainment
    "install_vlc"
)

# Development ------------------------------------------------------------------
declare -A install_base_devel=(
    [interface]="both"
    [message_process]="* Installing Package group base-devel "
    [arch]="sudo pacman -S --needed base-devel"
    [manjaro]="sudo pacman -S --needed base-devel"
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
    [manjaro]="5"
    [manjaro1]="cd ${HOME}"
    [manjaro2]="sudo pacman -S --needed git base-devel"
    [manjaro3]="git clone https://aur.archlinux.org/paru.git"
    [manjaro4]="cd paru && makepkg -si"
    [manjaro5]="cd .. && rm -rf paru"
)
declare -A install_python_pip=(
    [interface]="both"
    [message_process]="* Installing Python and pip package manager "
    [arch]="sudo pacman -S --needed python python-pip"
    [manjaro]="sudo pacman -S --needed python python-pip"
)
declare -A install_jdk_openjdk=(
    [interface]="both"
    [message_process]="* Installing OpenJDK Java development kit "
    [arch]="sudo pacman -S --needed jdk-openjdk"
    [manjaro]="sudo pacman -S --needed jdk-openjdk"
)
declare -A install_go=(
    [interface]="both"
    [message_process]="* Installing GO language "
    [arch]="sudo pacman -S --needed go"
    [manjaro]="sudo pacman -S --needed go"
)
declare -A install_nodejs_npm=(
    [interface]="both"
    [message_process]="* Installing Node.js and npm package manager "
    [arch]="sudo pacman -S --needed nodejs npm"
    [manjaro]="sudo pacman -S --needed nodejs npm"
)
declare -A install_zsh=(
    [interface]="both"
    [message_process]="* Installing Z shell (zsh) and plugins "
    [arch]="sudo pacman -S --needed zsh zsh-syntax-highlighting zsh-completions zsh-autosuggestions zsh-history-substring-search"
    [manjaro]="sudo pacman -S --needed zsh zsh-syntax-highlighting zsh-completions zsh-autosuggestions zsh-history-substring-search"
    [post]="chsh -s /bin/zsh" # Change default shell to zsh
)
declare -A install_powershell_bin=(
    [interface]="both"
    [message_process]="* Installing PowerShell "
    [arch]="paru -S --needed powershell-bin"
    [manjaro]="paru -S --needed powershell-bin"
    [post]="2"
    [post1]="pwsh -Command Install-Module -Name PowerShellGet  -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
    [post2]="pwsh -Command Install-Module -Name PSReadLine     -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
)
declare -A install_alacritty_git=(
    [interface]="gui"
    [message_process]="* Installing Alacritty (pulling from git) "
    [pre]="cd ${HOME}/.config/alacritty && git checkout linux"
    [arch]="paru -S --needed alacritty-git"
    [manjaro]="paru -S --needed alacritty-git"
)
declare -A install_unityhub_beta=(
    [interface]="gui"
    [message_process]="* Installing Unity Hub beta "
    [arch]="paru -S --needed unityhub-beta"
    [manjaro]="paru -S --needed unityhub-beta"
)
declare -A install_filezilla=(
    [interface]="gui"
    [message_process]="* Installing FileZilla "
    [arch]="sudo pacman -S --needed filezilla"
    [manjaro]="sudo pacman -S --needed filezilla"
)
declare -A install_neovim_git=(
    [interface]="both"
    [message_process]="* Installing Neovim (pulling from git) "
    [arch]="paru -S --needed neovim-git"
    [manjaro]="paru -S --needed neovim-git"
)
# Remote and Cloud -------------------------------------------------------------
declare -A install_bitwarden=(
    [interface]="gui"
    [message_process]="* Installing Bitwarden "
    [arch]="sudo pacman -S --needed bitwarden"
    [manjaro]="sudo pacman -S --needed bitwarden"
)
declare -A install_synergy_git=(
    [interface]="gui"
    [message_process]="* Installing Synergy "
    [pre]="cd ${HOME}/.config/Synergy && git checkout linux"
    [arch]="paru -S --needed synergy-git"
    [manjaro]="paru -S --needed synergy-git"
)
declare -A install_nextcloud_client=(
    [interface]="gui"
    [message_process]="* Installing Nextcloud client "
    [arch]="sudo pacman -S --needed nextcloud-client"
    [manjaro]="sudo pacman -S --needed nextcloud-client"
)
# Utilities --------------------------------------------------------------------
declare -A install_python_pynvim=(
    [interface]="both"
    [message_process]="* Installing Pynvim "
    [arch]="sudo pacman -S --needed python-pynvim"
    [manjaro]="sudo pacman -S --needed python-pynvim"
)
declare -A install_code_minimap=(
    [interface]="both"
    [message_process]="* Installing code-minimap "
    [arch]="paru -S --needed code-minimap"
    [manjaro]="paru -S --needed code-minimap"
)
declare -A install_unzip=(
    [interface]="both"
    [message_process]="* Installing Unzip "
    [arch]="sudo pacman -S --needed unzip"
    [manjaro]="sudo pacman -S --needed unzip"
)
declare -A install_fd=(
    [interface]="both"
    [message_process]="* Installing fd "
    [arch]="sudo pacman -S --needed fd"
    [manjaro]="sudo pacman -S --needed fd"
)
declare -A install_ripgrep=(
    [interface]="both"
    [message_process]="* Installing ripGREP "
    [arch]="sudo pacman -S --needed ripgrep"
    [manjaro]="sudo pacman -S --needed ripgrep"
)
declare -A install_xclip=(
    [interface]="gui"
    [message_process]="* Installing xclip "
    [arch]="sudo pacman -S --needed xclip"
    [manjaro]="sudo pacman -S --needed xclip"
)
declare -A install_sxhkd=(
    [interface]="gui"
    [message_process]="* Installing simple X hotkey daemon "
    [arch]="sudo pacman -S sxhkd"
    [manjaro]="sudo pacman -S sxhkd"
)
declare -A install_tmux=(
    [interface]="both"
    [message_process]="* Installing terminal multiplexer tmux "
    [arch]="sudo pacman -S tmux"
    [manjaro]="sudo pacman -S tmux"
)
declare -A install_tdrop=(
    [interface]="both"
    [message_process]="* Installing dropdown terminal wrapper tdrop "
    [arch]="sudo pacman -S tdrop"
    [manjaro]="sudo pacman -S tdrop"
)
declare -A install_ranger=(
    [interface]="both"
    [message_process]="* Installing Ranger A VIM-inspired filemanager for the console"
    [arch]="sudo pacman -S ranger"
    [manjaro]="sudo pacman -S ranger"
)
declare -A install_bat=(
    [interface]="both"
    [message_process]="* Installing Bat, a cat(1) clone with syntax highlighting and Git integration "
    [arch]="sudo pacman -S bat"
    [manjaro]="sudo pacman -S bat"
)
declare -A install_neofetch=(
    [interface]="both"
    [message_process]="* Installing system information tool Neofetch "
    [arch]="sudo pacman -S neofetch"
    [manjaro]="sudo pacman -S neofetch"
)
declare -A install_glances=(
    [interface]="gui"
    [message_process]="* Installing Glances "
    [arch]="sudo pacman -S --needed glances"
    [manjaro]="sudo pacman -S --needed glances"
)
declare -A install_electrum=(
    [interface]="gui"
    [message_process]="* Installing Electrum Bitcoin wallet "
    [arch]="sudo pacman -S --needed electrum"
    [manjaro]="sudo pacman -S --needed electrum"
)
declare -A install_etcher=(
    [interface]="gui"
    [message_process]="* Installing Etcher OS image flasher "
    [arch]="sudo pacman -S --needed etcher"
    [manjaro]="sudo pacman -S --needed etcher"
)
# Cosmetics
declare -A install_oh_my_posh=(
    [interface]="both"
    [message_process]="* Installing Oh My Posh "
    [arch]="paru -S oh-my-posh-git"
    [manjaro]="paru -S oh-my-posh-git"
)
declare -A install_starship=(
    [interface]="both"
    [message_process]="* Installing Starship "
    [arch]="sudo pacman -S --needed starship"
    [manjaro]="sudo pacman -S --needed starship"
)
# Fonts
declare -A install_fonts_firacode=(
    [interface]="gui"
    [message_process]="* Installing Fira Code Regular font "
    [dir]="mkdir -p ${HOME}/.local/share/fonts/ttf/FiraCode"
    [arch]="3"
    [arch1]="cd ${HOME}/.local/share/fonts/ttf/FiraCode"
    [arch2]="curl -fLo 'Fira Code Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"
    [arch3]="curl -fLo 'Fira Code Regular Nerd Font Complete Mono.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
    [manjaro]="3"
    [manjaro1]="cd ${HOME}/.local/share/fonts/ttf/FiraCode"
    [manjaro2]="curl -fLo 'Fira Code Regular Nerd Font Complete.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"
    [manjaro3]="curl -fLo 'Fira Code Regular Nerd Font Complete Mono.ttf' https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
    [post]="cd ${HOME}"
)
declare -A install_fonts_inter=(
    [interface]="gui"
    [message_process]="* Installing Inter font family "
    [arch]="sudo pacman -S --needed inter-font"
    [manjaro]="sudo pacman -S --needed inter-font"
)
# Editing ----------------------------------------------------------------------
declare -A install_marktext=(
    [interface]="gui"
    [message_process]="* Installing Mark Text "
    [arch]="paru -S --needed marktext"
    [manjaro]="paru -S --needed marktext"
)
declare -A install_blender=(
    [interface]="gui"
    [message_process]="* Installing Blender "
    [arch]="sudo pacman -S --needed blender"
    [manjaro]="sudo pacman -S --needed blender"
)
declare -A install_handbrake=(
    [interface]="gui"
    [message_process]="* Installing Handbrake "
    [arch]="sudo pacman -S --needed handbrake"
    [manjaro]="sudo pacman -S --needed handbrake"
)
declare -A install_avidemux_qt=(
    [interface]="gui"
    [message_process]="* Installing Avidemux "
    [arch]="sudo pacman -S --needed avidemux-qt"
    [manjaro]="sudo pacman -S --needed avidemux-qt"
)
declare -A install_audacity=(
    [interface]="gui"
    [message_process]="* Installing Audacity "
    [arch]="sudo pacman -S --needed audacity"
    [manjaro]="sudo pacman -S --needed audacity"
)
# Web & Chat -------------------------------------------------------------------
declare -A install_firefox=(
    [interface]="gui"
    [message_process]="* Installing Firefox "
    [arch]="sudo pacman -S --needed firefox"
    [manjaro]="sudo pacman -S --needed firefox"
)
declare -A install_thunderbird=(
    [interface]="gui"
    [message_process]="* Installing Thunderbird "
    [arch]="sudo pacman -S --needed thunderbird"
    [manjaro]="sudo pacman -S --needed thunderbird"
)
declare -A install_jdownloader2=(
    [interface]="gui"
    [message_process]="* Installing Jdownloader "
    [arch]="paru -S --needed jdownloader2"
    [manjaro]="paru -S --needed jdownloader2"
)
# Entertainment ----------------------------------------------------------------
declare -A install_vlc=(
    [interface]="gui"
    [message_process]="* Installing VLC "
    [arch]="sudo pacman -S --needed vlc"
    [manjaro]="sudo pacman -S --needed vlc"
)
