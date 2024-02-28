#!/bin/bash


#join kernel with dtbs
mkimage -f dojo.cfg dojo.bin

#package kernel for chromebook
vbutil_kernel --arch arm --pack kernel.bin --keyblock /usr/share/vboot/devkeys/kernel.keyblock --signprivate  /usr/share/vboot/devkeys/kernel_data_key.vbprivk --version 1 --config cmdline.txt --vmlinuz dojo.bin --bootloader dummy.txt

#report

echo "kernel part is now kernel.bin"

