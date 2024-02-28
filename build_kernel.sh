#!/bin/bash

# fetch mainline kernel
git clone --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

# configure kernel
cp kernel_config.txt linux/.config
cd linux
patch -p1 < ../patch_vanilla.patch
make olddefconfig

# build kernel
let NUM_PROC=4
[ -f /usr/bin/nproc ] && let NUM_PROC=`/usr/bin/nproc`

let "NUM_PROC = $NUM_PROC - 1"

echo "building kernel using number of processors:" $NUM_PROC

make -j$NUM_PROC
INSTALL_MOD_PATH=../modules/ make modules_install

# go back
cd ../modules/lib/modules/
tar cvzf ../../../../kernel_modules.tgz ./

cd ../../../..

./pack_kernel.sh

