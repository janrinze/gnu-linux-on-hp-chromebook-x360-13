#!/bin/bash

_repository="chromeos-kernel"
_commit="6533e11145e397a80ed22a969a5db818cf041524"

#get kernelsources
wget https://gitlab.collabora.com/google/$_repository/-/archive/$_commit/chromeos-kernel-$_commit.tar.gz

# unpack and rename
tar xvzf chromeos-kernel-$_commit.tar.gz
mv chromeos-kernel-$_commit kernel

# alternate method for getting a kernel
#git clone -b chromeos-6.1 --depth=1 https://chromium.googlesource.com/chromiumos/third_party/kernel kernel

# configure kernel
cp config.txt kernel/.config
cd kernel
make oldconfig

# build kernel
let NUM_PROC=4
[ -f /usr/bin/nproc ] && let NUM_PROC=`/usr/bin/nproc`

let "NUM_PROC = $NUM_PROC - 1"

echo "building kernel using number of processors:" $NUM_PROC

make -j$NUM_PROC
INSTALL_MOD_PATH=../modules/ make modules_install

# go back
cd ..

#join kernel with dtbs
mkimage -f cherry.cfg cherry.bin

#package kernel for chromebook
vbutil_kernel --arch arm --pack kernel.bin --keyblock /usr/share/vboot/devkeys/kernel.keyblock --signprivate  /usr/share/vboot/devkeys/kernel_data_key.vbprivk --version 1 --config cmdline.txt --vmlinuz cherry.bin --bootloader dummy.txt

#report

echo "kernel part is now kernel.bin"

