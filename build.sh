#!/bin/bash
set -e
nasm -f bin -o bootloader.bin bootloader.asm
nasm -f bin -o bootstrap.bin bootstrap.asm

# setup 4mb disk
dd if=/dev/zero of=boot.img bs=512 count=8192

# write bootloader binary code to image
dd if=bootloader.bin of=boot.img conv=notrunc

# write bootstrap code to image
dd if=bootstrap.bin of=boot.img seek=1 conv=notrunc

# write main code to image
dd if=./webserver/zig-out/bin/webserver.bin of=boot.img seek=2 conv=notrunc

qemu-system-x86_64 -monitor stdio -hda boot.img
