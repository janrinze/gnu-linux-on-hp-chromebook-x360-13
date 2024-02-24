#!/bin/bash


#join kernel with dtbs
mkimage -f cherry.cfg cherry.bin

#package kernel for chromebook
vbutil_kernel --arch arm --pack kernel.bin --keyblock /usr/share/vboot/devkeys/kernel.keyblock --signprivate  /usr/share/vboot/devkeys/kernel_data_key.vbprivk --version 1 --config cmdline.txt --vmlinuz cherry.bin --bootloader dummy.txt

#report

echo "kernel part is now kernel.bin"

