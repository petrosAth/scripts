#! /usr/bin/env python

import subprocess, sys

def start_vm(vm):
    subprocess.run(["virsh", "--connect", "qemu:///system", "start", vm])

def init(vm, gui):
    start_vm(vm)

args = sys.argv
init(args[1], args[2])
