Simple Target Image Builder
===========================

This repository contains a simple but straightforward system to create a bootable
Linux system for the I2SE Duckbill device series: it compiles U-Boot as boot loader,
compiles a Linux kernel with device tree blobs and creates a root filesystem
based on Debian Jessie 8 (armel). Then all is packed into a single disk image,
ready to be used on the SD card and/or Duckbill's internal eMMC.

This system is intended to be run on a recent Linux system, currently Debian Jessie 8
and Ubuntu 14.04 (LTS) is supported. The main reason for this is, that both distributions
come with precompiled cross compiler packages, however, if you have a working
cross compiler for 'armel' at hand, you can simply make it available in PATH and
change the CROSS_COMPILE setting in the Makefile.

Compared to other Embedded Linux build systems (e.g. ptxdist, OpenWrt...) this
system is limited by design. Please remember the following design decisions
when using it:
* This system is intended to be run on a developer (none-shared) host.
  No precautions are taken to prevent this system running in parallel with
  a second instance.
* This system heavily uses sudo to handle the file permissions of the target
  linux system properly. So ensure that the system user you are using has
  the required permissions.
* To populate the target root filesystem, the mountpoint /mnt is used. Please
  ensure, that you do not use it otherwise while running this system.
* You need a working internet connection to download the Debian packages for the
  target system. Only some minor efforts are done to cache the downloaded files.


Workflow to generate an image file
----------------------------------

To ensure that your host environment is setup corrctly, we have prepared a Makefile target
which helps you to install the distro packages as required. Simply issue a

```
$ make jessie-requirements
```

or

```
$ make trusty-requirements
```

and see which packages are fetched and installed via apt. Note, that the multistrap tool
in Ubuntu is faulty, so it's patched at this stage when the broken package is detected.
This step need to be run only once.

This repository uses submodules to link/access various required sources and tools. So
after cloning this repo, you have to init the submodules first:

```
$ make prepare
```

After this, compile the required tools, U-Boot and linux kernel:

```
$ make tools u-boot linux
```

Now it's time to create the basic Debian root filesystem with multistrap:

```
$ make rootfs
```

However, we want to customize it a little bit:

```
$ make install
```

And now, we pack all into a single SD card/eMMC image and split it into smaller chunks
so that we can deploy it during manufacturing process:

```
$ make disk-image
```

The resulting images/image parts are here:

```
$ ls -la images
```