#!/bin/bash

declare -A themes

themes["dracula"]="86004d"           #86004d
themes["everforest-dark"]="274000"   #274000
themes["everforest-medium"]="274000" #274000
themes["everforest-soft"]="274000"   #274000
themes["gruvbox"]="7e7d00"           #7e7d00
themes["monokai"]="d3004c"           #d3004c
themes["nord"]="003848"              #003848
themes["onedark-cool"]="00569c"      #00569c
themes["onedark-dark"]="004e8e"      #004e8e
themes["onedark-darker"]="005793"    #005793
themes["onedark-deep"]="0066bb"      #0066bb
themes["onedark-warm"]="004680"      #004680
themes["onedark-warmer"]="004e8e"    #004e8e
themes["selenized-black"]="555555"   #555555
themes["selenized-dark"]="00313e"    #00313e
themes["solarized-osaka"]="002f3b"   #002f3b

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
