#!/bin/bash

start_vm() {
    vm=$1

    virsh --connect qemu:///system start ${vm}
}

virt_manager() {
    vm=$1

    virt-manager --connect qemu:///system --show-domain-console ${vm} &
}

wait_timer() {
    echo "Please wait while the VM is booting"
    for ((i = $1; i > 0; i--)); do
        echo "$i..."
        sleep 1
    done
}

remote_desktop() {
    vm=$1

    if [[ ${vm} = "winVMdesign" ]]; then
        wait_timer 10
        remmina -c /home/petrosath/.local/share/remmina/group_rdp_winvmdesign_192-168-122-3.remmina &
        exit
    elif [[ ${vm} = "winVMmain" ]]; then
        wait_timer 10
        remmina -c /home/petrosath/.local/share/remmina/group_rdp_winvmmain_192-168-122.134.remmina &
        exit
    elif [[ ${vm} = "winVMwork" ]]; then
        wait_timer 10
        remmina -c /home/petrosath/.local/share/remmina/group_rdp_winvmwork_192-168-122.54.remmina &
        exit
    fi
}

looking_glass() {
    vm=$1
    is_lg_vm=("winVMdesign" "winVMmain" "winVMwork")

    for vm in ${is_lg_vm}; do
        wait_timer 2
        looking-glass-client win:size=1920x1080 &
        exit
    done
}

start_gui() {
    vm=$1
    gui=$2

    if [[ ${gui} = "rd" ]]; then
        remote_desktop ${vm}
    elif [[ ${gui} = "lg" ]]; then
        looking_glass ${vm}
    elif [[ ${gui} = "vm" ]]; then
        virt_manager ${vm}
    else
        exit
    fi
}

init() {
    vm=$1
    gui=$2
    is_valid_vm=("arch" "winVMdesign" "winVMmain" "winVMwork")

    for vm_in_list in ${is_valid_vm[@]}; do
        if [[ ${vm_in_list} = ${vm} ]]; then
            start_vm ${vm}
            start_gui ${vm} ${gui}
            disown
        fi
    done
}

init $1 $2
