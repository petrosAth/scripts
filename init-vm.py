#! /usr/bin/env python

import subprocess, sys

def start_vm(vm):
    subprocess.run(["virsh", "--connect", "qemu:///system", "start", vm])

def virt_manager(vm):
    subprocess.run(["virt-manager", "--connect", "qemu:///system", "--show-domain-console", vm])

def show_vm(vm, gui):
    virt_manager(vm)

def init(vm, gui):
    start_vm(vm)
    show_vm(vm, gui)

init(sys.argv[1], sys.argv[2])
