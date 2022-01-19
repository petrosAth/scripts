#!/bin/bash

# GitHub user: petrosAth
# Name: Petros Athanasoulis
# Email: develop@athanasoulis.me

# Citation
# Make Your dotfiles Portable With Git and a Simple Bash Script
# Part 1: https://freddiecarthy.com/blog/make-your-dotfiles-portable-with-git-and-a-simple-bash-script
# Part 2: https://freddiecarthy.com/blog/use-git-and-bash-to-automate-your-developer-tooling
# github repo: https://github.com/gjunkie/dotfiles-starter-kit

# Depoly script call command
# `bash -c "$(curl -#fL raw.githubusercontent.com/petrosAth/scripts/master/deploy/linux/install.sh)"`

# user of the github repo to be cloned
GITHUB_USER="petrosAth"
# name of the github repo to be cloned
GITHUB_REPO="linux-config"
# folder name where the repo will be cloned
DIR="${HOME}/dotfiles"

VALID_INTERFACE=("CLI" "GUI" "both")
VALID_DISTRO=("Arch" "Manjaro")

INTERFACE=""
DISTRO=""

_process() {
    printf "$(tput setaf 6) %s...$(tput sgr0)\n" "$@"
}

_success() {
    local message=$1
    printf "%s✓ Success:%s\n" "$(tput setaf 2)" "$(tput sgr0) $message"
}

get_user_input() {
    local question=$1
    local -n selection=$2
    local -n valid_array=$3

    printf '\n%s' "${question}"; echo
    # List the available options
    printf '* %s\n' "${valid_array[@]^}"; echo

    # Keep asking for user input until it is in a valid array (VALID_INTERFACE, VALID_DISTRO)
    while [[ ! " ${valid_array[*],,} " =~ " ${selection,,} " ]] ; do
        read -p "Pick one from the list: " selection
    done

    # change to lower case
    selection=${selection,,}
}

get_distro() {
    # Ask for distribution
    local question="Which distribution are you installing?"
    get_user_input "$question" DISTRO VALID_DISTRO

    # Capitalize the first letter only and print install message
    _process "* Installing packages for ${DISTRO^}"
}

get_interface() {
    # Ask for distribution
    local question="What type of interface are you using?"
    get_user_input "$question" INTERFACE VALID_INTERFACE

    # If the choice is "both" leave it lower case
    if [[ "${INTERFACE}" == "both" ]] ; then
        _process "* Installing packages for ${INTERFACE} CLI and GUI"
    # Else if it is "cli" or "gui" capitalize all
    else
        _process "* Installing packages for ${INTERFACE^^}"
    fi
}

update_system() {
    _process "* Updating system "
    case ${DISTRO} in
        arch)
            sudo pacman -Syu ;;
        manjaro)
            sudo pacman -Syu ;;
    esac

    [[ $? ]] && _success "System updated"
}

clone_dotfiles() {
    # Install git
    _process "* Installing git"
    sudo pacman -S --needed git

    # Clone repository with its submodules
    _process "* Cloning repository ${GITHUB_REPO}"
    git clone --recurse-submodules https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git ${DIR}
	# Checkout all submodules on master branch to get rid of detached head state
	cd ${DIR} && git submodule foreach 'git checkout master'
	# Checkout git submodule on linux specific branch
	cd ${DIR}/git && git checkout linux && cd ${HOME}
	cd ${DIR}/scripts && git checkout source-array && cd ${HOME}

    [[ $? ]] && _success "dotfiles have been cloned"
}

execute() {
    local action=$1
    # Use shift to remove first argument from the array
    shift
    local commands=("$@")
    for command in ${commands[@]} ; do
        local execute=${action}[${command}]
        # If a key exists continue
        if [[ ${!execute} ]] ; then
            # regex for findint number characters
            local re='^[0-9]+$'
            # If the key ends with a number start an execution loop
            if [[ ${!execute} =~ $re ]] ; then
                for (( i=1; i <= ${!execute}; ++i ))
                do
                    command_number=${action}[${command}${i}]
                    ${!command_number}
                done
            # Else execute the key's commands
            else
                ${!execute}
            fi
        fi
    done
}

actions_sequence() {
    # Array of keys of which their commands will be executed
    local commands=("pre" "${DISTRO}" "post")
    for action in ${actions_list[@]} ; do
        local action_interface=${action}[interface]
        local action_distro=${action}[${DISTRO}]
        local action_process=${action}[message_process]
        local action_success=${action}[message_success]
        # If the action has a key with the current distro's name continue
        if [[ ${!action_distro} ]] ; then
            # Check if the interface key has the value selected
            if [[ ${INTERFACE} == ${!action_interface} ]] || [[ ${INTERFACE} == "both" ]] || [[ ${!action_interface} == "both" ]] ; then
                # If the action has an process message print it
                [[ ${!action_process} ]] && _process "${!action_process}"
                # Send the action's commands for execution
                execute $action "${commands[@]}"
                # If the action's commands completed successfully and has a success message, print it
                if [[ ${!action_success} ]] && [[ $? ]] ; then
                    _success "${!action_success}"
                fi
            fi
        fi
    done

    [[ $? ]] && _success "All packages have been installed"
}

create_symlinks() {
    _process "* Creating symlinks "
    # Array of keys of which their commands will be executed
    local commands=("dir" "link")
    for action in ${actions_list[@]} ; do
        local action_interface=${action}[interface]
        local action_distro=${action}[${DISTRO}]
        local action_dir=(${action}[dir])
        local action_dir_array=(${!action_dir})
        local action_link=(${action}[link])
        local action_link_array=(${!action_link})
        # If the action has a key with the current distro's name continue
        if [[ ${!action_distro} ]] ; then
            # Check if the interface key has the value selected
            if [[ ${INTERFACE} == ${!action_interface} ]] || [[ ${INTERFACE} == "both" ]] || [[ ${!action_interface} == "both" ]] ; then
                # Print the directory to be created
                [[ ${!action_dir} ]] && _process "* Creating directory ${action_dir_array[1]} "
                # Print the link to be done
                [[ ${!action_link} ]] && _process "* Linking ${action_link_array[2]} → ${action_link_array[3]} "
                # Send the action's mkdir and ln commands for execution
                execute $action "${commands[@]}"
            fi
        fi
    done

    [[ $? ]] && _success "dotfiles have been linked"
}

deploy() {
    # Ask for distribution to be installed
    get_distro
    # Ask for interface to be used
    get_interface
    # Test again if a valid selection has been made by the user
    if [[ " ${valid_array[*],,} " =~ " ${selection,,} " ]] ; then
        update_system
        clone_dotfiles

        # Source actions list
        source "${DIR}/scripts/deploy/linux/actions.sh"

        actions_sequence
        create_symlinks
    fi
}

# Call all the functions!!!
deploy

[[ $? ]] && _success "OS installed and configured"
