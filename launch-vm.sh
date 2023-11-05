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
    vm=$1

    if [[ ${vm} = "winWS" ]]; then
        sleep 2
        looking-glass-client &
    fi
}

start_gui() {
    gui=$1
    vm=$2

    if [[ ${gui} = "vmm" ]]; then
        virt_manager ${vm}
    fi

    if [[ ${gui} = "rd" ]]; then
        remote_desktop ${vm}
    fi

    if [[ ${gui} = "lg" ]]; then
        looking_glass ${vm}
    fi
}

init() {
    vm=$1
    gui=$2
    is_valid_vm=("arch" "winWS")

    for vm_in_list in ${is_valid_vm[@]}; do
        if [[ ${vm_in_list} = ${vm} ]]; then
            start_vm ${vm}
            start_gui() ${gui} ${vm}
        fi
    done
}

init $1 $2
