#! /usr/bin/env python

import os, subprocess, sys, time

def start_vm(vm):
    subprocess.run(["virsh", "--connect", "qemu:///system", "start", vm])

def virt_manager(vm):
    subprocess.run(["virt-manager", "--connect", "qemu:///system", "--show-domain-console", vm])

def remote_desktop(vm):
    home_path = os.getenv("HOME")
    remmina_path = ".local/share/remmina"
    has_rd = { "winWS": "group_rdp_winws_192-168-200-121" }

    if vm in has_rd.keys():
        time.sleep(10)
        subprocess.run(["remmina", "-c", f"{home_path}/{remmina_path}/{has_rd[vm]}.remmina"])

def looking_glass(vm):
    has_lg = [ "winWS" ]

    if vm in has_lg:
        time.sleep(2)
        subprocess.run(["looking-glass-client"])


def show_vm(vm, gui):
    virt_manager(vm)
    remote_desktop(vm)
    looking_glass(vm)

def init(vm, gui):
    start_vm(vm)
    show_vm(vm, gui)

init(sys.argv[1], sys.argv[2])
