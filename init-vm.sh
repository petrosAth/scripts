#!/bin/bash

start_vm() {
    virsh --connect qemu:///system start winWS
}

remote_desktop() {
    sleep 10
    remmina -c /home/petrosath/.local/share/remmina/group_rdp_winws_192-168-200-121.remmina &
}

looking_glass() {
    sleep 2
    looking-glass-client &
}

init() {
    start_vm

    if [[ $1 = "rd" ]]; then
        remote_desktop
    fi

    if [[ $1 = "lg" ]]; then
        looking_glass
    fi
}

init $1
