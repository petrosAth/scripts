#!/bin/bash

# Array of actions to be taken by the auto installation script
actions_list=(
# Package Managers
    "install_yay"
# Development
    "install_base_devel"
    "install_python_pip"
    "install_jdk_openjdk"
    "install_go"
    "install_nodejs"
    "install_npm"
    "install_github_cli"
    "install_zsh"
    "install_powershell_bin"
    "install_unityhub_beta"
    "install_filezilla"
    "install_neovim_git"                   # Neovim
# Remote and Cloud
    "install_openssh"
    "install_bitwarden"
    "install_synergy_git"
    "install_nextcloud_client"
# Utilities
    "install_python_pynvim"                # Neovim
    "install_code_minimap"                 # Neovim
    "install_unzip"                        # Neovim
    "install_fd"                           # Neovim
    "install_ripgrep"                      # Neovim
    "install_xclip"                        # Neovim
    "install_zsh_syntax_highlighting"      # zsh
    "install_zsh_completions"              # zsh
    "install_zsh_autosuggestions"          # zsh
    "install_zsh_history_substring_search" # zsh
    "install_alacritty_git"
    "install_kdeconnect"
    "install_glances"
    "install_korganizer"                   # Nextcloud
    "install_kaddressbook"                 # Nextcloud
    "install_kontact"                      # Nextcloud
    "install_kdepim_addons"                # Nextcloud
    "install_electrum"
    "install_etcher"
# Cosmetics
    "install_starship"
    "install_oh_my_posh"
    "install_latte_dock"
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

# Package managers -------------------------------------------------------------
declare -A install_yay=(
    [interface]="both"
    [message_process]="* Installing yay "
    [arch]="4"
    [arch1]="sudo pacman -S --needed git base-devel"
    [arch2]="git clone https://aur.archlinux.org/yay-bin.git"
    [arch3]="cd yay-bin && makepkg -si"
    [arch4]="cd .. && rm -rf yay-bin"
    [manjaro]="sudo pacman -S --needed yay"
)
# Development ------------------------------------------------------------------
declare -A install_base_devel=(
    [interface]="both"
    [message_process]="* Installing Package group base-devel "
    [arch]="sudo pacman -S --needed base-devel"
    [manjaro]="sudo pacman -S --needed base-devel"
)
declare -A install_python_pip=(
    [interface]="both"
    [message_process]="* Installing Python package manager (pip) "
    [arch]="sudo pacman -S --needed python-pip"
    [manjaro]="sudo pacman -S --needed python-pip"
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
declare -A install_nodejs=(
    [interface]="both"
    [message_process]="* Installing Node.js "
    [arch]="sudo pacman -S --needed nodejs"
    [manjaro]="sudo pacman -S --needed nodejs"
)
declare -A install_npm=(
    [interface]="both"
    [message_process]="* Installing Node.js package manager (npm) "
    [arch]="sudo pacman -S --needed npm"
    [manjaro]="sudo pacman -S --needed npm"
)
declare -A install_github_cli=(
    [interface]="both"
    [message_process]="* Installing GitHub CLI "
    [arch]="sudo pacman -S --needed github-cli"
    [manjaro]="sudo pacman -S --needed github-cli"
)
declare -A install_zsh=(
    [interface]="both"
    [message_process]="* Installing Z shell (zsh) "
    [arch]="sudo pacman -S --needed zsh"
    [manjaro]="sudo pacman -S --needed zsh"
    [post]="chsh -s /bin/zsh"                                     # Change default shell to zsh
)
declare -A install_powershell_bin=(
    [interface]="both"
    [message_process]="* Installing PowerShell "
    [arch]="yay -S --needed powershell-bin"
    [manjaro]="yay -S --needed powershell-bin"
    [post]="2"
    [post1]="pwsh -Command Install-Module -Name PowerShellGet  -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
    [post2]="pwsh -Command Install-Module -Name PSReadLine     -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
)
declare -A install_unityhub_beta=(
    [interface]="gui"
    [message_process]="* Installing Unity Hub beta "
    [arch]="yay -S --needed unityhub-beta"
    [manjaro]="yay -S --needed unityhub-beta"
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
    [arch]="yay -S --needed neovim-git"
    [manjaro]="yay -S --needed neovim-git"
)
# Remote and Cloud -------------------------------------------------------------
declare -A install_openssh=(
    [interface]="both"
    [message_process]="* Installing OpenSSH "
    [arch]="sudo pacman -S --needed openssh"
    [manjaro]="sudo pacman -S --needed openssh"
)
declare -A install_bitwarden=(
    [interface]="gui"
    [message_process]="* Installing Bitwarden "
    [arch]="sudo pacman -S --needed bitwarden"
    [manjaro]="sudo pacman -S --needed bitwarden"
)
declare -A install_synergy_git=(
    [interface]="gui"
    [message_process]="* Installing Synergy "
    [pre]="cd ${DIR}/synergy && git checkout linux"
    [arch]="yay -S --needed synergy-git"
    [manjaro]="yay -S --needed synergy-git"
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
    [arch]="yay -S --needed code-minimap"
    [manjaro]="yay -S --needed code-minimap"
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
declare -A install_zsh_syntax_highlighting=(
    [interface]="both"
    [message_process]="* Installing Z shell syntax highlighting plugin "
    [arch]="sudo pacman -S --needed zsh-syntax-highlighting"
    [manjaro]="sudo pacman -S --needed zsh-syntax-highlighting"
)
declare -A install_zsh_completions=(
    [interface]="both"
    [message_process]="* Installing Z shell auto completion plugin "
    [arch]="sudo pacman -S --needed zsh-completions"
    [manjaro]="sudo pacman -S --needed zsh-completions"
)
declare -A install_zsh_autosuggestions=(
    [interface]="both"
    [message_process]="* Installing Z shell ghost text plugin "
    [arch]="sudo pacman -S --needed zsh-autosuggestions"
    [manjaro]="sudo pacman -S --needed zsh-autosuggestions"
)
declare -A install_zsh_history_substring_search=(
    [interface]="both"
    [message_process]="* Installing Z shell smart history search plugin "
    [arch]="sudo pacman -S --needed zsh-history-substring-search"
    [manjaro]="sudo pacman -S --needed zsh-history-substring-search"
)
declare -A install_alacritty_git=(
    [interface]="gui"
    [message_process]="* Installing Alacritty (pulling from git) "
    [pre]="cd ${DIR}/alacritty && git checkout linux"
    [arch]="yay -S --needed alacritty-git"
    [manjaro]="yay -S --needed alacritty-git"
)
declare -A install_kdeconnect=(
    [interface]="gui"
    [message_process]="* Installing KDE Connect "
    [arch]="sudo pacman -S --needed kdeconnect"
    [manjaro]="sudo pacman -S --needed kdeconnect"
)
declare -A install_glances=(
    [interface]="gui"
    [message_process]="* Installing Glances "
    [arch]="sudo pacman -S --needed glances"
    [manjaro]="sudo pacman -S --needed glances"
)
declare -A install_korganizer=( # Sync nextcloud with kde callendar widget
    [interface]="gui"
    [message_process]="* Installing Korganizer "
    [arch]="sudo pacman -S --needed korganizer"
    [manjaro]="sudo pacman -S --needed korganizer"
)
declare -A install_kaddressbook=( # Sync nextcloud with kde callendar widget
    [interface]="gui"
    [message_process]="* Installing Kaddressbook "
    [arch]="sudo pacman -S --needed kaddressbook"
    [manjaro]="sudo pacman -S --needed kaddressbook"
)
declare -A install_kontact=( # Sync nextcloud with kde callendar widget
    [interface]="gui"
    [message_process]="* Installing Kontact "
    [arch]="sudo pacman -S --needed kontact"
    [manjaro]="sudo pacman -S --needed kontact"
)
declare -A install_kdepim_addons=( # Sync nextcloud with kde callendar widget
    [interface]="gui"
    [message_process]="* Installing KDE PIM addons "
    [arch]="sudo pacman -S --needed kdepim-addons"
    [manjaro]="sudo pacman -S --needed kdepim-addons"
)
declare -A install_electrum=(
    [interface]="gui"
    [message_process]="* Installing Electrum Bitcoin wallet "
    [arch]="pacman -S --needed electrum"
    [manjaro]="pacman -S --needed electrum"
)
declare -A install_etcher=(
    [interface]="gui"
    [message_process]="* Installing Etcher OS image flasher "
    [arch]="pacman -S --needed etcher"
    [manjaro]="pacman -S --needed etcher"
)
# Cosmetics
declare -A install_oh_my_posh=(
    [interface]="both"
    [message_process]="* Installing Oh My Posh "
    [arch]="yay -S oh-my-posh-git"
    [manjaro]="yay -S oh-my-posh-git"
)
declare -A install_starship=(
    [interface]="both"
    [message_process]="* Installing Starship "
    [arch]="sudo pacman -S --needed starship"
    [manjaro]="sudo pacman -S --needed starship"
)
declare -A install_latte_dock=(
    [interface]="gui"
    [message_process]="* Installing Latte dock "
    [arch]="sudo pacman -S --needed latte-dock"
    [manjaro]="sudo pacman -S --needed latte-dock"
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
    [arch]="yay -S --needed marktext"
    [manjaro]="yay -S --needed marktext"
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
    [arch]="yay -S --needed jdownloader2"
    [manjaro]="yay -S --needed jdownloader2"
)
# Entertainment ----------------------------------------------------------------
declare -A install_vlc=(
    [interface]="gui"
    [message_process]="* Installing VLC "
    [arch]="sudo pacman -S --needed vlc"
    [manjaro]="sudo pacman -S --needed vlc"
)
