#!/bin/bash

declare -A themes

themes["dracula"]="ff79c6"           # #ff79c6
themes["everforest-dark"]="a7c080"   # #a7c080
themes["everforest-medium"]="a7c080" # #a7c080
themes["everforest-soft"]="a7c080"   # #a7c080
themes["gruvbox"]="98971a"           # #98971a
themes["monokai"]="f92672"           # #f92672
themes["nord"]="88c0d0"              # #88c0d0
themes["onedark-cool"]="5ab0f6"      # #5ab0f6
themes["onedark-dark"]="61afef"      # #61afef
themes["onedark-darker"]="4fa6ed"    # #4fa6ed
themes["onedark-deep"]="41a7fc"      # #41a7fc
themes["onedark-warm"]="68aee8"      # #68aee8
themes["onedark-warmer"]="57a5e5"    # #57a5e5
themes["selenized-black"]="777777"   # #777777
themes["selenized-dark"]="6d858b"    # #6d858b
themes["solarized-osaka"]="6f8589"   # #6f8589

set-backlight-breathing() {
    color=$1
    g512-led -fx breathing keys "${color}" 0f
}

set-backlight-static() {
    color=$1
    g512-led -a "${color}"
}

init_dbus_watcher() {
    color=$1
    dbus-monitor --session "type='signal',interface='org.freedesktop.ScreenSaver'" \
        | while read -r line; do
            if echo "$line" | grep -q "ActiveChange"; then
                read -r state_line
                if echo "$state_line" | grep -q "true"; then
                    set-backlight-breathing "${color}"
                elif echo "$state_line" | grep -q "false"; then
                    set-backlight-static "${color}"
                fi
            fi
        done
}

init() {
    command=$1
    color="${themes[$SYSTEM_THEME]}"

    if [[ ${command} = "watcher" ]]; then
        init_dbus_watcher "${color}"
    else
        set-backlight-static "${color}"
    fi
}

init "$1"
