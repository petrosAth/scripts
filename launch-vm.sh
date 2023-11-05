#!/bin/bash

start_vm() {
    vm=$1

    virsh --connect qemu:///system start ${vm}
}

virt_manager() {
    vm=$1

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
    vm=$1
    gui=$2

    if [[ ${gui} = "rd" ]]; then
        remote_desktop ${vm}
    elif [[ ${gui} = "lg" ]]; then
        looking_glass ${vm}
    else
        virt_manager ${vm}
    fi
}

init() {
    vm=$1
    gui=$2
    is_valid_vm=("arch" "pop_os" "testDE-clone" "winWS")

    for vm_in_list in ${is_valid_vm[@]}; do
        if [[ ${vm_in_list} = ${vm} ]]; then
            start_vm ${vm}
            start_gui ${vm} ${gui}
        fi
    done
}

init $1 $2
