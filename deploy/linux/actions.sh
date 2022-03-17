#!/bin/bash

#|=< Array of actions to be taken by the auto installation script >===========|#
actions_list=(
#|-< Development >------------------------------------------------------------|#
    "install_base_devel"
    "install_paru"
    "install_python_pip"
    "install_jdk_openjdk"
    "install_go"
    "install_nodejs_npm"
    "install_stylua_git"
    "install_zsh"
    "install_powershell_bin"
    "install_kitty"
    "install_alacritty"
    "install_unityhub_beta"
    "install_filezilla"
    "install_neovim_git"                   # Neovim
    "install_python_pynvim"                # Neovim dependancy
    "install_xclip"                        # Neovim clipboard sync
    "install_unzip"                        # Neovim LSP Installer dependancy
    "install_fd"                           # Neovim plugin telescope dependancy
    "install_ripgrep"                      # Neovim plugin telescope dependancy
#|-< Remote and Cloud >-------------------------------------------------------|#
    "install_bitwarden"
    "install_synergy_git"
    "install_nextcloud_client"
#|-< Utilities >--------------------------------------------------------------|#
    "install_trash_cli"
    "install_corectrl"
    "install_sxhkd"
    "install_tmux"
    "install_tdrop"
    "install_ranger"
    "install_bat"
    "install_neofetch"
    "install_btop"
    "install_electrum"
    "install_etcher"
#|-< Cosmetics >--------------------------------------------------------------|#
    "install_oh_my_posh"
    "install_starship"
#|-< Fonts >------------------------------------------------------------------|#
    "install_inter_font"
    "install_fira_code_font"
    "install_nerd_fonts_symbols"
#|-< Editing >----------------------------------------------------------------|#
    "install_onlyoffice"
    "install_blender"
    "install_handbrake"
    "install_avidemux_qt"
    "install_audacity"
#|-< Web & Chat >-------------------------------------------------------------|#
    "install_firefox"
    "install_thunderbird"
    "install_jdownloader2"
#|-< Entertainment >----------------------------------------------------------|#
    "install_vlc"
)
#|============================================================================|#


#|=< Installation commands >==================================================|#
#|-< Development >------------------------------------------------------------|#
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
declare -A install_stylua_git=(
    [interface]="both"
    [message_process]="* Installing StyLua, an opinionated Lua code formatter "
    [arch]="paru -S --needed stylua-git"
    [manjaro]="paru -S --needed stylua-git"
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
declare -A install_kitty=(
    [interface]="gui"
    [message_process]="* Installing kitty The fast, feature-rich, GPU based terminal emulator "
    [arch]="sudo pacman -S --needed kitty"
    [manjaro]="sudo pacman -S --needed kitty"
)
declare -A install_alacritty=(
    [interface]="gui"
    [message_process]="* Installing Alacritty, a cross-platform, OpenGL terminal emulator "
    [pre]="cd ${HOME}/.config/alacritty && git checkout linux"
    [arch]="sudo pacman -S --needed alacritty"
    [manjaro]="sudo pacman -S --needed alacritty"
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
declare -A install_python_pynvim=(
    [interface]="both"
    [message_process]="* Installing Pynvim "
    [arch]="sudo pacman -S --needed python-pynvim"
    [manjaro]="sudo pacman -S --needed python-pynvim"
)
declare -A install_xclip=(
    [interface]="gui"
    [message_process]="* Installing xclip "
    [arch]="sudo pacman -S --needed xclip"
    [manjaro]="sudo pacman -S --needed xclip"
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
#|-< Remote and Cloud >-------------------------------------------------------|#
declare -A install_bitwarden=(
    [interface]="gui"
    [message_process]="* Installing Bitwarden, the most trusted open source password manager for business "
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
#|-< Utilities >--------------------------------------------------------------|#
declare -A install_trash_cli=(
    [interface]="both"
    [message_process]="* Installing trash-cli, command line interface to the freedesktop.org trashcan "
    [arch]="sudo pacman -S --needed trash-cli"
    [manjaro]="sudo pacman -S --needed trash-cli"
)
declare -A install_corectrl=(
    [interface]="gui"
    [message_process]="* Installing CoreCtrl hardware control tool "
    [arch]="paru -S --needed corectrl"
    [manjaro]="paru -S --needed corectrl"
)
declare -A install_sxhkd=(
    [interface]="gui"
    [message_process]="* Installing simple X hotkey daemon "
    [arch]="sudo pacman -S --needed sxhkd"
    [manjaro]="sudo pacman -S sxhkd"
)
declare -A install_tmux=(
    [interface]="both"
    [message_process]="* Installing terminal multiplexer tmux "
    [arch]="sudo pacman -S --needed tmux"
    [manjaro]="sudo pacman -S --needed tmux"
)
declare -A install_tdrop=(
    [interface]="both"
    [message_process]="* Installing dropdown terminal wrapper tdrop "
    [arch]="sudo pacman -S --needed tdrop"
    [manjaro]="sudo pacman -S --needed tdrop"
)
declare -A install_ranger=(
    [interface]="both"
    [message_process]="* Installing Ranger A VIM-inspired filemanager for the console"
    [arch]="sudo pacman -S --needed ranger"
    [manjaro]="sudo pacman -S --needed ranger"
    [post]="2"
    [post1]="ranger --copy-config=scope"
    [post2]="git clone https://github.com/alexanderjeurissen/ranger_devicons ${HOME}/.config/ranger/plugins/ranger_devicons"
)
declare -A install_bat=(
    [interface]="both"
    [message_process]="* Installing Bat, a cat(1) clone with syntax highlighting and Git integration "
    [arch]="sudo pacman -S --needed bat"
    [manjaro]="sudo pacman -S --needed bat"
)
declare -A install_neofetch=(
    [interface]="both"
    [message_process]="* Installing system information tool Neofetch "
    [arch]="sudo pacman -S --needed neofetch"
    [manjaro]="sudo pacman -S --needed neofetch"
)
declare -A install_btop=(
    [interface]="gui"
    [message_process]="* Installing BTOP++, a monitor of resources "
    [arch]="sudo pacman -S --needed btop"
    [manjaro]="sudo pacman -S --needed btop"
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
#|-< Cosmetics >--------------------------------------------------------------|#
declare -A install_oh_my_posh=(
    [interface]="both"
    [message_process]="* Installing Oh My Posh "
    [arch]="paru -S --needed oh-my-posh-git"
    [manjaro]="paru -S --needed oh-my-posh-git"
)
declare -A install_starship=(
    [interface]="both"
    [message_process]="* Installing Starship "
    [arch]="sudo pacman -S --needed starship"
    [manjaro]="sudo pacman -S --needed starship"
)
#|-< Fonts >------------------------------------------------------------------|#
declare -A install_inter_font=(
    [interface]="gui"
    [message_process]="* Installing Inter font family "
    [arch]="sudo pacman -S --needed inter-font"
    [manjaro]="sudo pacman -S --needed inter-font"
)
declare -A install_fira_code_font=(
    [interface]="gui"
    [message_process]="* Installing Fira Code font family "
    [arch]="sudo pacman -S --needed ttf-fira-code"
    [manjaro]="sudo pacman -S --needed ttf-fira-code"
)
declare -A install_nerd_fonts_symbols=(
    [interface]="gui"
    [message_process]="* Installing Fira Code font family "
    [arch]="sudo pacman -S --needed ttf-nerd-fonts-symbols"
    [manjaro]="sudo pacman -S --needed ttf-nerd-fonts-symbols"
)
#|-< Editing >----------------------------------------------------------------|#
declare -A install_onlyoffice=(
    [interface]="gui"
    [message_process]="* Installing OnlyOffice. Open-source office suite that combines text, spreadsheet and presentation editors "
    [arch]="paru -S --needed onlyoffice-bin"
    [manjaro]="sudo pacman -S --needed onlyoffice-desktopeditors"
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
#|-< Web & Chat >-------------------------------------------------------------|#
declare -A install_firefox=(
    [interface]="gui"
    [message_process]="* Installing Firefox "
    [arch]="sudo pacman -S --needed firefox"
    [manjaro]="sudo pacman -S --needed firefox"
)
declare -A install_thunderbird=(
    [interface]="gui"
    [message_process]="* Installing Thunderbird, a free email application that's easy to set up and customize "
    [arch]="sudo pacman -S --needed thunderbird"
    [manjaro]="sudo pacman -S --needed thunderbird"
)
declare -A install_jdownloader2=(
    [interface]="gui"
    [message_process]="* Installing Jdownloader "
    [arch]="paru -S --needed jdownloader2"
    [manjaro]="paru -S --needed jdownloader2"
)
#|-< Entertainment >----------------------------------------------------------|#
declare -A install_vlc=(
    [interface]="gui"
    [message_process]="* Installing VLC "
    [arch]="sudo pacman -S --needed vlc"
    [manjaro]="sudo pacman -S --needed vlc"
)
#|============================================================================|#
