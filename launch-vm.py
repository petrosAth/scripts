#! /usr/bin/env python

import os, subprocess, sys, time

def start_vm(vm):
    subprocess.run(["virsh", "--connect", "qemu:///system", "start", vm])

def virt_manager(vm, start):
    has_gui = False
    has_vmm = [ "arch", "testDE" ]

    if vm in has_vmm:
        if start == True:
            subprocess.run(["sudo", "virt-manager", "--connect", "qemu:///system", "--show-domain-console", vm])
        has_gui = True

    return has_gui, "Virtual Machine Manager graphical console"

def remote_desktop(vm, start):
    has_gui = False
    home_path = os.getenv("HOME")
    remmina_path = ".local/share/remmina"
    has_rd = { "winWS": "group_rdp_winws_192-168-200-121" }

    if vm in has_rd.keys():
        if start == True:
            time.sleep(10)
            subprocess.run(["remmina", "-c", f"{home_path}/{remmina_path}/{has_rd[vm]}.remmina"])
        has_gui = True

    return has_gui, "Remmina"

def looking_glass(vm, start):
    has_gui = False
    has_lg = [ "winWS" ]

    if vm in has_lg:
        if start == True:
            time.sleep(2)
            subprocess.run(["looking-glass-client"])
        has_gui = True

    return has_gui, "Looking Glass"

def no_gui_error(vm, gui = ""):
    clr_red = "\033[0;31m"
    clr_white = "\033[1;37m"
    if gui == "invalid":
        print(f"{clr_red}Wrong interface option!")
    else:
        print(f"{clr_white}{gui} {clr_red}is not configured to be used with {clr_white}{vm}{clr_red} virtual machine!")

def show_vm(vm, gui, start):
    has_gui = False
    gui_name = ""
    start_gui = True if start == True else False

    if gui == "rd":
        has_gui, gui_name = remote_desktop(vm, start_gui)
    elif gui == "lg":
        has_gui, gui_name = looking_glass(vm, start_gui)
    elif gui == "":
        has_gui = virt_manager(vm, start_gui)

    return has_gui, gui_name

def is_running(vm):
    vm_is_running = subprocess.run(["sudo", "virsh", "list"], capture_output=True, text=True, check=True).stdout
    if vm in vm_is_running:
        return True

def demote():
    def result():
        os.setgid(1000)
        os.setuid(1000)
    return result

def init(vm, gui):
    has_gui, gui_name = show_vm(vm, gui, False)
    if has_gui:
        if not is_running(vm):
            start_vm(vm)
        demote()
        show_vm(vm, gui, True)
    elif gui_name != "":
        no_gui_error(vm, gui_name)
    else:
        no_gui_error(vm, "invalid")

if __name__ == '__main__':
    args = [ sys.argv[1], "" ]

    if len(sys.argv) > 2:
        args[1] = sys.argv[2]

    init(args[0], args[1])
