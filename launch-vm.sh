#!/bin/bash

start_vm() {
    vm=$1

    virsh --connect qemu:///system start ${vm}
}

virt_manager() {
    vm=$1

    virt-manager --connect qemu:///system --show-domain-console ${vm}
}

remote_desktop() {
    vm=$1

    if [[ ${vm} = "winWS" ]]; then
        sleep 10
        remmina -c /home/petrosath/.local/share/remmina/group_rdp_winws_192-168-200-121.remmina &
    fi
}

looking_glass() {
    sleep 2
    looking-glass-client &
}

init() {
    gui=$1
    vm=$2

    start_vm ${vm}

    if [[ ${gui} = "vm" ]]; then
        virt_manager ${vm}
    fi

    if [[ ${gui} = "rd" ]]; then
        remote_desktop ${vm}
    fi

    if [[ ${gui} = "lg" ]]; then
        looking_glass ${vm}
    fi
}

init $1 $2
