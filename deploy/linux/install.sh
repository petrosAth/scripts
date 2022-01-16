#!/usr/bin/env bash
# Srouces
# Make Your dotfiles Portable With Git and a Simple Bash Script
# Part 1: https://freddiecarthy.com/blog/make-your-dotfiles-portable-with-git-and-a-simple-bash-script
# Part 2: https://freddiecarthy.com/blog/use-git-and-bash-to-automate-your-developer-tooling
# github repo: https://github.com/gjunkie/dotfiles-starter-kit

INTERFACE=""
GITHUB_USER="petrosAth"
GITHUB_REPO="linux-config"
DIR="${HOME}/dotfiles"

_process() {
    printf "$(tput setaf 6) %s...$(tput sgr0)\n" "$@"
}

_success() {
    local message=$1
    printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

get_interface() {
	# Ask for interface type
    read -p "Select package list (GUI or CLI): " INTERFACE

    # change to lower case
    INTERFACE=${INTERFACE,,}

    # If valid selection, change to single character, else exit
    if [[ ${INTERFACE} == "gui" ]] ; then
        INTERFACE="g"
        _process "→ Installing packages for Graphical User Interface"
    elif [[ ${INTERFACE} == "cli" ]] ; then
        INTERFACE="c"
        _process "→ Installing packages for Command Line Interface"
    else
        echo "Not a valid selection"
        command || exit 1
    fi
}

update_system() {
    # Update keyring
    _process "→ Updating keyring"
    sudo pacman -Sy --needed archlinux-keyring

    # Update system
    _process "→ Updating system"
    sudo pacman -Syu

    [[ $? ]] && _success "System updated"
}

clone_dotfiles() {
    # Install git
    _process "→ Installing git"
    sudo pacman -S --needed git

    # Clone repository with its submodules
    _process "→ Cloning repository ${GITHUB_REPO}"
    git clone --recurse-submodules https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git ${DIR}
	# Checkout all submodules on master branch to get rid of detached head state
	git submodule foreach 'git checkout master'
	# Checkout git submodule on linux specific branch
	cd ${DIR}/git && git checkout linux && cd ${HOME}

    [[ $? ]] && _success "dotfiles have been cloned"
}

link_dotfiles() {
    # symlink files to the HOME directory.
    if [[ -f "${DIR}/scripts/deploy/linux/symlinks.txt" ]]; then
        _process "→ Symlinking dotfiles"

        # Set variable for list of files
        files="${DIR}/scripts/deploy/linux/symlinks.txt"

        # Store IFS separator within a temp variable
        OIFS=$IFS
        # Set the separator to a carriage return & a new line break
        # read in passed-in file and store as an array
        IFS=$'\r\n'
        links=($(cat "${files}"))

        # Loop through array of files
        for index in ${!links[*]}
        do
            for link in ${links[$index]}
            do
				# skip lines starting with #
				if [[ ! ${file[0]} == "#" ]] ; then
					_process "→ Linking ${links[$index]}"
					# set IFS back to space to split string on
					IFS=$' '
					# create an array of line items
					file=(${links[$index]})

					# if a parent directory doesn't exist, create it
					if [[ ! -e "${HOME}/${file[2]}" ]] ; then
						mkdir "${HOME}/${file[2]}"
					fi

					# Create symbolic link
					ln -fs "${DIR}/${file[0]}" "${HOME}/${file[1]}"
				fi
            done
            # set separater back to carriage return & new line break
            IFS=$'\r\n'
        done

        # Reset IFS back
        IFS=$OIFS

        # Change default shell to zsh
        chsh -s /bin/zsh

        [[ $? ]] && _success "dotfiles have been linked"
    fi
}

install_packages() {
    # Set variables for list of files
    package_list="${DIR}/scripts/deploy/linux/packages.txt"

    # Store IFS separator within a temp variable
    OIFS=$IFS
    # Set the separator to a carriage return & a new line break
    IFS=$'\r\n'
    # read in passed-in file and store as an array
    packages=($(cat "${package_list}"))

    _process "→ Installing packages from Arch official repository"
    for index in ${!packages[*]}
    do
        for package in ${packages[$index]}
        do
            # set IFS back to space to split string on
            IFS=$' '
            # create an array of line items
            file=(${packages[$index]})
            # Install package
            if [[ ${file[0]} == "o" ]]; then
                if [[ ${file[1]} == ${INTERFACE} ]] || [[ ${file[1]} == "b" ]] ; then
                    _process "→ Installing ${file[2]}"
                    sudo pacman -S --needed ${file[2]}
                fi
            fi
        done
        # set separater back to carriage return & new line break
        IFS=$'\r\n'
    done

    _process "→ Installing yay"
    if ! pacman -Qi yay &>/dev/null 2>&1 ; then
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin && makepkg -si
        cd .. && rm -rf yay-bin
    fi

    _process "→ Installing packages from Arch user repository (AUR)"
    for index in ${!packages[*]}
    do
        for package in ${packages[$index]}
        do
            # set IFS back to space to split string on
            IFS=$' '
            # create an array of line items
            file=(${packages[$index]})
            # Install package
            if [[ ${file[0]} == "u" ]]; then
                if [[ ${file[1]} == ${INTERFACE} ]] || [[ ${file[1]} == "b" ]] ; then
                    _process "→ Installing ${file[2]}"
                    yay -S --needed ${file[2]}
                fi
            fi
        done
        # set separater back to carriage return & new line break
        IFS=$'\r\n'
    done

    # Reset IFS back
    IFS=$OIFS

	# Install powershell modules only if powershell is installed already
    if pacman -Qi powershell &>/dev/null 2>&1 ; then
        pwsh -Command Install-Module -Name PowerShellGet  -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force
        pwsh -Command Install-Module -Name PSReadLine     -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force
    fi

	# Install oh-my-posh
    _process "→ Installing oh-my-posh"
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh

    [[ $? ]] && _success "All packages installed"
}

deploy() {
    get_interface
    update_system
    if [[ ${INTERFACE} == "c" ]] || [[ ${INTERFACE} == "g" ]] ; then
        clone_dotfiles
        install_packages
        link_dotfiles
    fi
}

deploy

[[ $? ]] && zsh && _success "OS installed and configured"