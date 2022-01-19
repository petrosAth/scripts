# Help
## Distribution addition
New distributions can be added in two steps.
First add the distribution name in the VALID_DISTRO array located at the top
of install.sh file. For cosmetic purposes capitalize the first letter only.
```
VALID_DISTRO=("Arch" "Manjaro" "Debian" "Mint")
```

Finally add the distribution name along with the update command for it in the
function <update_system> located in install.sh as well.
```
update_system() {
    _process "* Updating system "
    case ${DISTRO} in
        arch)
            sudo pacman -Syu ;;
        manjaro)
            sudo pacman -Syu ;;
        debian)
            sudo apt-get update && apt-get upgrade ;;
    esac

    [[ $? ]] && _success "System updated"
}
```

## Action addition
The actions that will be automatically taken by the script are administered here.
They must be declared and placed in the action_list using the exact same name.
```
action_list=(
    "install_base_devel"
)

declare -A install_base_devel=(
    [interface]="both"
    [arch]="pacman -Syu --needed base_devel"
)
```

## Configuration
- The interface type that the package will be installed is stated using the
`[interface]` key and take three values:
```
[interface]="cli"
[interface]="gui"
[interface]="both"
```

- The distributions that the package will be installed along with the
installation commands for those distributions are stated using the
`[*distribution*]` key:
```
[manjaro]="pacman -Syu blender"
[debian]="apt-get install blender"
```

- If there are any commands that have to be executed before the installation
they can be added using the `[pre]` key:
```
[pre]="cd ${HOME}"
```

- If there are any commands that have to be executed after the installation
they can be added using the `[post]` key:
```
[post]="chsh -s /bin/zsh" # Change default shell to zsh
```

- Directories can be created using the `[dir]` key:
```
[dir]="mkdir ${HOME}/.config/gh"
```

- Links can be made using the `[link]` key:
```
[link]="ln -fs ${DIR}/gh/config.yml ${HOME}/.config/gh/config.yml"
```

- Pre-installation announcements can be made using the `[message_process]` key:
```
[message_process]="* Installing Package group base-devel "
```

- Post-installation announcements can be made using the `[message_success]` key:
```
[message_success]="Package group base-devel installed "
```

- In case there are more than one commands that have to be issued for the
installation of the package, we can enter them using the following method:
```
[arch]="6"
[arch1]="sudo pacman -S --needed git base_devel"
[arch2]="git clone https://aur.archlinux.org/yay-bin.git"
[arch3]="cd yay-bin
[arch4]="makepkg -si"
[arch5]="cd ..
[arch6]="rm -rf yay-bin"
```
>The above method can be applied to any key except:
`[interface] [message_process] [message_success]`
