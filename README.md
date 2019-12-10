# Linux memory filesystem image builder using Docker

Derived from mfslinux, Copyright (c) 2018 Martin Matuska <mm at FreeBSD.org>, Version 0.1.3

## Upstream project (mfslinux) description

This is a GNU Makefile with a set of scripts and configuration files that
generates a bootable ISO file with a working Linux distribution.
This minimal distribution gets completely loaded into memory.

mfslinux is currently based on [OpenWrt](https://openwrt.org)

## Build-time requirements
 - x86_64 Linux and Docker
 - see [BUILD](./BUILD.md) for building instructions

## Runtime requirements
 - recommended system memory: two to three times that of image size

## Example command to run or test image
 - TERM=vt220 qemu-system-x86_64 -enable-kvm -cpu SandyBridge-IBRS -smp 2 -net nic,vlan=0,model=virtio -net user -m 2048 -boot c -curses -display curses -serial mon:stdio -echr 2 -drive file=mfslinux.iso,media=disk,if=virtio,index=0,format=raw,readonly,discard=unmap,detect-zeroes=unmap,index=0

## Variations

Other Linux images (besides the CentOS 7 example) can be built with a few modifications to the Dockerfile

## License
 - [GNU General Public License version 3](./LICENSE.md) or higher

mfslinux project homepage: http://mfslinux.vx.sk
