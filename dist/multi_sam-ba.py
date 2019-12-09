#!/usr/bin/python3
# ----------------------------------------------------------------------------
#                Microchip Microcontroller Software Support
#                       SAM Software Package License
# ----------------------------------------------------------------------------
# Copyright (c) 2019, Microchip Technology Inc.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following condition is met:
#
# - Redistributions of source code must retain the above copyright notice,
# this list of conditions and the disclaimer below.
#
# Microchip's name may not be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# DISCLAIMER:  THIS SOFTWARE IS PROVIDED BY MICROCHIP "AS IS" AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED. IN NO EVENT SHALL MICROCHIP BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ----------------------------------------------------------------------------

import os
import re
import sys
from serial.tools.list_ports import comports
from threading import Thread

samba_vid = 0x03eb
samba_pid = 0x6124

def insert_port(cmd, conn):
    cmd = re.sub("(" + conn + "):", "\\1:%port%", cmd)
    cmd = re.sub("(" + conn + ")([^:])", "\\1:%port%\\2", cmd)
    cmd = re.sub("(" + conn + ")$", "\\1:%port%", cmd)
    return cmd

class Samba(Thread):
    def __init__(self, cmd, port):
        Thread.__init__(self)
        self.cmd = cmd.replace("%port%", port)
        self.port = port
        self.status = 0

    def run(self):
        self.status = os.system(self.cmd)

def main():
    samba_ports = []
    for info in comports():
        if info.vid != None and info.vid == samba_vid and info.pid != None and info.pid == samba_pid:
            samba_ports.append(info)

    print("Found SAM-BA ports:")
    for info in samba_ports:
        print("{:20} {}".format(info.device, info.description))

    cmd = ""
    for arg in sys.argv:
        cmd += "{} ".format(arg)
    cmd += "\n"
    cmd = cmd.replace(sys.argv[0], "sam-ba")
    cmd = insert_port(cmd, "-p\s+serial")
    cmd = insert_port(cmd, "--port\s+serial")
    cmd = insert_port(cmd, "--port=serial")
    cmd = insert_port(cmd, "-p\s+secure")
    cmd = insert_port(cmd, "--port\s+secure")
    cmd = insert_port(cmd, "--port=secure")

    threads = [Samba(cmd, info.device.replace("/dev/", "")) for info in samba_ports]

    for th in threads:
        th.start()

    for th in threads:
        th.join()

    for th in threads:
        if th.status != 0:
            print("{} Failed".format(th.port))
        else:
            print("{} Passed".format(th.port))

main()
