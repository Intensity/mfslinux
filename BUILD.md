# Linux memory filesystem build instructions

Derived from mfslinux, Copyright (c) 2018 Martin Matuska <mm at FreeBSD.org>

- See `Creating an image` section for build instructions

## Project status

Upstream project files kept intact; however, the build process used here is Docker, using configuration files mostly orthogonal to the original project

Current example creates a CentOS 7 image. However, another version or distribution can be used by modifying the Dockerfile

## Requirements

 - Docker to build
 - ZeroTier executable artifact
 - ZeroTier address of network to request to join, and SSH key to add

## Creating an image

 - Add `zerotier-one` executable artifact to top level directory
 - Modify `Dockerfile` to replace ZeroTier ID network to join (currently set to the `earth` address), and the SSH key to add
 - `docker build .`
 - Retrieve `mfslinux.iso` generated artifact
