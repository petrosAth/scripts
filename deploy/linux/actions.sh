#!/bin/bash
# Packages for auto installagion

# Help -------------------------------------------------------------------------
# Package addition -------------------------------------------------------------
# The packages that will be auto-installed by the script are administered here
# They must be declared and placed in the package_list using the exact same name

# package_list=(
#     "install_base_devel"
# )

# declare -A install_base_devel=(
#     [interface]="both"
#     [arch]="pacman -Syu --needed base_devel"
# )

# Configuration ----------------------------------------------------------------
# The interface type that the package will be installed is stated using the
# following key and has three options:
#     [interface]="cli"
#     [interface]="gui"
#     [interface]="both"

# The distributions that the package will be installed along with the
# installation commands for those distributions are stated using the following
# key:
#     [manjaro]="pacman -Syu blender"
#     [debian]="apt-get install blender"

# In case there are more than one commands that have to be issued for the
# installation of the package, we can enter them using the following method:
#     [arch]="4"
#     [arch1]="sudo pacman -S --needed git base_devel"
#     [arch2]="git clone https://aur.archlinux.org/yay-bin.git"
#     [arch3]="cd yay-bin
#     [arch4]="makepkg -si"
#     [arch5]="cd ..
#     [arch6]="rm -rf yay-bin"

# If there are any commands that have to be executed before the installation
# they can be added using the key [pre]:
#     [pre]="2"
#     [pre1]="mkdir ${HOME}/.config/gh"
#     [pre2]="ln -fs ${HOME}/dotfiles/gh/config.yml ${HOME}/.config/gh/config.yml"

# If there are any commands that have to be executed after the installation
# they can be added using the key [post]:
#     [post]="2"
#     [post1]="mkdir ${HOME}/.config/gh"
#     [post2]="ln -fs ${HOME}/dotfiles/gh/config.yml ${HOME}/.config/gh/config.yml"
# ------------------------------------------------------------------------------

# List of packages for installation
actions_list=(
# Package Managers
    "install_package_manager"
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
    "install_neovim_nightly_bin" # Neovim or Neovim plugin dependancy
    "install_python_pynvim"      # Neovim or Neovim plugin dependancy
    "install_code_minimap_bin"   # Neovim or Neovim plugin dependancy
# Remote and Cloud
    "install_openssh"
    "install_bitwarden"
    "install_nextcloud_client"
# Utilities
    "install_unzip"              # Neovim or Neovim plugin dependancy
    "install_fd"                 # Neovim or Neovim plugin dependancy
    "install_ripgrep"            # Neovim or Neovim plugin dependancy
    "install_starship"
    "install_wget"
    "install_oh_my_posh"
    "install_solaar"
    "install_kdeconnect"
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
declare -A install_package_manager=(
    [interface]="both"
    [message_process]="* Installing yay "
    [arch]="6"
    [arch1]="sudo pacman -Suy --needed git base-devel"
    [arch2]="git clone https://aur.archlinux.org/yay-bin.git"
    [arch3]="cd yay-bin"
    [arch4]="makepkg -si"
    [arch5]="cd .."
    [arch6]="rm -rf yay-bin"
    [manjaro]="sudo pacman -Syu yay"
)
# Development ------------------------------------------------------------------
declare -A install_base_devel=(
    [interface]="both"
    [message_process]="* Installing base-devel "
    [arch]="sudo pacman -Syu --needed base-devel"
    [manjaro]="sudo pacman -Syu --needed base-devel"
)
declare -A install_git=(
    [interface]="both"
    [message_process]="* Installing Git "
    [arch]="sudo pacman -Syu --needed git"
    [manjaro]="sudo pacman -Syu --needed git"
    [link]="ln -fs ${DIR}/git/.gitconfig ${HOME}/.gitconfig"
)
declare -A install_github_cli=(
    [interface]="both"
    [message_process]="* Installing GitHub CLI "
    [arch]="sudo pacman -Syu --needed github-cli"
    [manjaro]="sudo pacman -Syu --needed github-cli"
    [dir]="mkdir ${HOME}/.config/gh"
    [link]="ln -fs ${DIR}/gh/config.yml ${HOME}/.config/gh/config.yml"
)
declare -A install_go=(
    [interface]="both"
    [message_process]="* Installing GO "
    [arch]="sudo pacman -Syu --needed go"
    [manjaro]="sudo pacman -Syu --needed go"
)
declare -A install_nodejs=(
    [interface]="both"
    [message_process]="* Installing Node.js "
    [arch]="sudo pacman -Syu --needed nodejs"
    [manjaro]="sudo pacman -Syu --needed nodejs"
)
declare -A install_npm=(
    [interface]="both"
    [message_process]="* Installing npm "
    [arch]="sudo pacman -Syu --needed npm"
    [manjaro]="sudo pacman -Syu --needed npm"
)
declare -A install_python_pip=(
    [interface]="both"
    [message_process]="* Installing pip "
    [arch]="sudo pacman -Syu --needed python-pip"
    [manjaro]="sudo pacman -Syu --needed python-pip"
)
declare -A install_zsh=(
    [interface]="both"
    [message_process]="* Installing Z shell "
    [arch]="sudo pacman -Syu --needed zsh"
    [manjaro]="sudo pacman -Syu --needed zsh"
    [link]="ln -fs ${DIR}/zsh/.zshrc ${HOME}/.zshrc"
    [post]="chsh -s /bin/zsh" # Change default shell to zsh
)
declare -A install_powershell_bin=(
    [interface]="both"
    [message_process]="* Installing PowerShell "
    [arch]="yay -Syu --needed powershell-bin"
    [manjaro]="yay -Syu --needed powershell-bin"
    [dir]="mkdir ${HOME}/.config/powershell"
    [link]="ln -fs ${DIR}/powershell/Microsoft.PowerShell_profile.ps1 ${HOME}/.config/powershell/Microsoft.PowerShell_profile.ps1"
    [post]="2"
    [post1]="pwsh -Command Install-Module -Name PowerShellGet  -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
    [post2]="pwsh -Command Install-Module -Name PSReadLine     -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force"
)
declare -A install_unityhub_beta=(
    [interface]="gui"
    [message_process]="* Installing Unity Hub beta "
    [arch]="yay -Syu --needed unityhub-beta"
    [manjaro]="yay -Syu --needed unityhub-beta"
)
declare -A install_filezilla=(
    [interface]="gui"
    [message_process]="* Installing FileZilla "
    [arch]="sudo pacman -Syu --needed filezilla"
    [manjaro]="sudo pacman -Syu --needed filezilla"
)
declare -A install_neovim_nightly_bin=(
    [interface]="both"
    [message_process]="* Installing Neovim nightly "
    [arch]="yay -Syu --needed neovim-nightly-bin"
    [manjaro]="yay -Syu --needed neovim-nightly-bin"
    [dir]="mkdir ${HOME}/.config"
    [link]="ln -fs ${DIR}/nvim ${HOME}/.config/nvim"
)
declare -A install_python_pynvim=(
    [interface]="both"
    [message_process]="* Installing python-pynvim "
    [arch]="sudo pacman -Syu --needed python-pynvim"
    [manjaro]="sudo pacman -Syu --needed python-pynvim"
)
declare -A install_code_minimap_bin=(
    [interface]="both"
    [message_process]="* Installing code-minimap "
    [arch]="yay -Syu --needed code-minimap-bin"
    [manjaro]="yay -Syu --needed code-minimap-bin"
)
# Remote and Cloud -------------------------------------------------------------
declare -A install_openssh=(
    [interface]="both"
    [message_process]="* Installing OpenSSH "
    [arch]="sudo pacman -Syu --needed openssh"
    [manjaro]="sudo pacman -Syu --needed openssh"
)
declare -A install_bitwarden=(
    [interface]="gui"
    [message_process]="* Installing Bitwarden "
    [arch]="sudo pacman -Syu --needed bitwarden"
    [manjaro]="sudo pacman -Syu --needed bitwarden"
)
declare -A install_nextcloud_client=(
    [interface]="gui"
    [message_process]="* Installing Nextcloud client "
    [arch]="sudo pacman -Syu --needed nextcloud-client"
    [manjaro]="sudo pacman -Syu --needed nextcloud-client"
)
# Utilities --------------------------------------------------------------------
declare -A install_unzip=(
    [interface]="both"
    [message_process]="* Installing unzip "
    [arch]="sudo pacman -Syu --needed unzip"
    [manjaro]="sudo pacman -Syu --needed unzip"
)
declare -A install_fd=(
    [interface]="both"
    [message_process]="* Installing fd "
    [arch]="sudo pacman -Syu --needed fd"
    [manjaro]="sudo pacman -Syu --needed fd"
)
declare -A install_ripgrep=(
    [interface]="both"
    [message_process]="* Installing ripGREP "
    [arch]="sudo pacman -Syu --needed ripgrep"
    [manjaro]="sudo pacman -Syu --needed ripgrep"
)
declare -A install_starship=(
    [interface]="both"
    [message_process]="* Installing Starship "
    [arch]="sudo pacman -Syu --needed starship"
    [manjaro]="sudo pacman -Syu --needed starship"
)
declare -A install_wget=(
    [interface]="both"
    [message_process]="* Installing wget "
    [arch]="sudo pacman -Syu --needed wget"
    [manjaro]="sudo pacman -Syu --needed wget"
)
declare -A install_oh_my_posh=(
    [interface]="both"
    [message_process]="* Installing Oh My Posh "
    [arch]="2"
    [arch1]="sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh"
    [arch2]="sudo chmod +x /usr/local/bin/oh-my-posh"
    [manjaro]="2"
    [manjaro1]="sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh"
    [manjaro2]="sudo chmod +x /usr/local/bin/oh-my-posh"
)
declare -A install_solaar=(
    [interface]="gui"
    [message_process]="* Installing Solaar "
    [arch]="sudo pacman -Syu --needed solaar"
    [manjaro]="sudo pacman -Syu --needed solaar"
)
declare -A install_kdeconnect=(
    [interface]="gui"
    [message_process]="* Installing KDE Connect "
    [arch]="sudo pacman -Syu --needed kdeconnect"
    [manjaro]="sudo pacman -Syu --needed kdeconnect"
)
# Editing ----------------------------------------------------------------------
declare -A install_blender=(
    [interface]="gui"
    [message_process]="* Installing Blender "
    [arch]="sudo pacman -Syu --needed blender"
    [manjaro]="sudo pacman -Syu --needed blender"
)
declare -A install_handbrake=(
    [interface]="gui"
    [message_process]="* Installing Handbrake "
    [arch]="sudo pacman -Syu --needed handbrake"
    [manjaro]="sudo pacman -Syu --needed handbrake"
)
declare -A install_avidemux_qt=(
    [interface]="gui"
    [message_process]="* Installing Avidemux "
    [arch]="sudo pacman -Syu --needed avidemux-qt"
    [manjaro]="sudo pacman -Syu --needed avidemux-qt"
)
declare -A install_audacity=(
    [interface]="gui"
    [message_process]="* Installing Audacity "
    [arch]="sudo pacman -Syu --needed audacity"
    [manjaro]="sudo pacman -Syu --needed audacity"
)
# Web & Chat -------------------------------------------------------------------
declare -A install_uget=(
    [interface]="gui"
    [message_process]="* Installing uget "
    [arch]="sudo pacman -Syu --needed uget"
    [manjaro]="sudo pacman -Syu --needed uget"
)
declare -A install_firefox=(
    [interface]="gui"
    [message_process]="* Installing Firefox "
    [arch]="sudo pacman -Syu --needed firefox"
    [manjaro]="sudo pacman -Syu --needed firefox"
)
declare -A install_thunderbird=(
    [interface]="gui"
    [message_process]="* Installing Thunderbird "
    [arch]="sudo pacman -Syu --needed thunderbird"
    [manjaro]="sudo pacman -Syu --needed thunderbird"
)
# Entertainment ----------------------------------------------------------------
declare -A install_vlc=(
    [interface]="gui"
    [message_process]="* Installing VLC "
    [arch]="sudo pacman -Syu --needed vlc"
    [manjaro]="sudo pacman -Syu --needed vlc"
)
