#! /usr/bin/env python

import subprocess, sys, time

def start_vm(vm):
    subprocess.run(["virsh", "--connect", "qemu:///system", "start", vm])

def virt_manager(vm):
    subprocess.run(["virt-manager", "--connect", "qemu:///system", "--show-domain-console", vm])

def looking_glass(vm):
    has_lg = [ "winWS" ]

    if vm in has_lg:
        time.sleep(2)
        subprocess.run(["looking-glass-client"])


def show_vm(vm, gui):
    virt_manager(vm)
    looking_glass(vm)

def init(vm, gui):
    start_vm(vm)
    show_vm(vm, gui)

init(sys.argv[1], sys.argv[2])
