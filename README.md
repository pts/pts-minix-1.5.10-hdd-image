# pts-minix-1.5.10-hdd-image: bootable HDD images of Minix 1.5.10 i86 and i386

pts-minix-1.5.10-hdd-image provides bootable HDD disk images containing
Minix 1.5.10 i86 and i386. It works in QEMU >=2.11.1, VirtualBox and
possibly other emulators. These images can be download and used right away,
unlike the official Minix 1.5.10 i86 release, which has to be installed from
floppy (images) first. These images also contain some extra goodes such as
man pages and the ShoeLace bootloader.

[Minix](https://web.archive.org/web/20250923051203/http://www.minix3.org/)
and
[Minix-vmd](https://web.archive.org/web/20250710222725/http://www.minix-vmd.org/)
are open source under the 3-clause BSD license since 2000-04-07, applying
retroactively to versions released earlier as well, see the
[announcement](https://web.archive.org/web/20250726134343/https://minix1.woodhull.com/faq/mxlicense.html).

The only official release of Minix 1.5 was the Minix 1.5.10 i86 (real mode
on the Intel 8086 CPU and 16-bit protected mode on the Intel 286 or later or
compatible CPU) on 1990-06-01. The [Minix 1.5.10 i86 installer floppy
images](https://minix1.woodhull.com/faq/mxlicense.html) are available for
download. It includes source code of the kernel and the userspace commands,
except for the assembler, the linker and the non-frontend tools of the
modified ACK C compiler. Minix is self-hosting in the sense that the kernel
and most commands can be recompiled on Minix itself. Some commands needs
cross-compilation, because the linker runs out of memory when run on Minix
i86, because Minix i86 limits the data size (which includes .rodata, .data,
.bss, stack, argv and environ strings) to 64 KiB.

The official Minix 1.5.10 release doesn't include any documentation, even
the man (manual) pages are missing. The document *Reference Manual for the
Minix 1.5 Demonstration Disk* (1991)
[demoman.pdf](https://web.archive.org/web/20230531061144/https://www.pliner.com/macminix/documentation/demoman.pdf)
is available as a separate download. It has many chapters missing, such as
the install instructions. The Minix community has made some [man
pages](https://web.archive.org/web/20041229164522/http://minix1.hampshire.edu/pub/minix.1.5/man/)
and also some [extra man
pages](https://web.archive.org/web/20191024060435id_/https://minix1.woodhull.com/pub/refman.1.5/ExtManPgs.shar)
(see also their
[announcement](https://web.archive.org/web/20191024060435/https://minix1.woodhull.com/pub/refman.1.5/ExtManPgs.txt))
in section 7.

The floppy driver in the Minix kernels 1.5.10--2.0.4 doesn't work with the
floppy emulated by QEMU 2.11.1. (It means that it can load the kernel and
the ramdisk image from floppy very slowly, but after that it can't read or
write the floppy.) Maybe it works in VirtualBox or other emulators.
Fortunately, the HDD images provided by pts-minix-1.5.10-hdd-image are
bootable without floppy.

## Running Minix 1.5.10 i86 on Linux in QEMU

This image is based on the official [Minix 1.5.10
i86](http://download.minix3.org/previous-versions/Intel-1.5/) release
(1990-06-01). It contains only a few config file changes.

Download the file
[minix-1.5.10-i86.vhd.zip](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86.vhd.zip)
`wget -O minix-1.5.10-i86.vhd.zip
https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86.vhd.zip`),
and decompress it with `unzip -o minix-1.5.10-i86.vhd.zip` or
`gunzip -S.zip -fk minix-1.5.10-i86.vhd.zip`.

Optionally, you can inspect the contents of the filesystem:

```
mkdir -p p
sudo mount -t minix -o ro,loop minix-1.5.10-i86.vhd p2
find p -depth -type f
ls -ld p/minix
sudo umount p
```

Install QEMU. On Debian and Ubuntu, the install command is `sudo apt-get
install qemu-system-x86`. The command `qemu-system-i386 --version` should
work. The version number it displays should be >=2.11.1.

Run this command to start the emulator running Minix 1.5.10:
`qemu-system-i386 -M pc-1.0 -m 4 -drive file=minix-1.5.10-i86.vhd,format=vpc
-boot c -debugcon stdio -net none`. (VirtualBox also works, but the VM guest
setup is different.) In the newly appearing black QEMU window, in less than
a second, at the `login:` prompt, type `root` and press <Enter>. There is no
password.

To undo the changes you've made, exit the emulator (by closing its window),
remove the image file and decompress it again: `rm -f MINIX15.vhd && unzip
-o MINIX15.vhd.zip`.

The HDD disk image contains a single Minix v1 filesystem of size ~64 MiB,
which is the maximum Minix v1 filesystem size, and Minix 1.5.10 doesn't
support any other filesystems.

The official Minix 1.5.10 release supports booting from floppy only. For
booting directly from HDD, the ShoeLace bootloader was used commonly in
1989--1994 (until Minix 1.6.25 came out, which has included its own boot.c).
ShoeLace is not part of Minix, it has to be downloaded ([ShoeLace source
code](https://web.archive.org/web/20251203014657id_/https://mirror.math.princeton.edu/pub/oldlinux/Linux.old/bin-src/shoelace.minix-1.0a.tar.Z])),
compiled and installed separately. In this image above, instead of ShoeLace,
the
[mbr_bootlace.nasm](https://github.com/pts/mkfs-bootable-minix1/blob/master/mbr_bootlace.nasm)
bootloader is used, which is placed in the first 1024 bytes of the HDD image
file. It loads the kernel from the file named `/minix` in the Minix v1
filesystem on the HDD image file.

This HDD image with is a useful starting point for compiling and installing
the official [Minix 1.6.25
i86](http://download.minix3.org/previous-versions/Intel-1.6/) source patch
release (1994-04) from source.

## Running Minix 1.5.10 i86 with goodies on Linux in QEMU

This image is based on the official [Minix 1.5.10
i86](http://download.minix3.org/previous-versions/Intel-1.5) release
(1990-06-01) with some additional goodies (last one dated 1997-12-16) and a
few config file changes.

Download the file
[minix-1.5.10-i86-and-goodies.vhd.zip](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86-and-goodies.vhd.zip)
`wget -O minix-1.5.10-i86-and-goodies.vhd.zip
https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86-and-goodies.vhd.zip`),
and decompress it with `unzip -o minix-1.5.10-i86-and-goodies.vhd.zip` or
`gunzip -S.zip -fk minix-1.5.10-i86-and-goodies.vhd.zip`.

Optionally, you can inspect the contents of the filesystem:

```
mkdir -p p
sudo mount -t minix -o ro,loop minix-1.5.10-i86-and-goodies.vhd p2
find p -depth -type f
sudo umount p
```

Install QEMU. On Debian and Ubuntu, the install command is `sudo apt-get
install qemu-system-x86`. The command `qemu-system-i386 --version` should
work. The version number it displays should be >=2.11.1.

Run this command to start the emulator running Minix 1.5.10:
`qemu-system-i386 -M pc-1.0 -m 4 -drive
file=minix-1.5.10-i86-and-goodies.vhd,format=vpc -boot c
-debugcon stdio -net none`. (VirtualBox also works, but the VM guest setup
is different.) In the newly appearing black QEMU window, in less than a
second, at the `login:` prompt, type `root` and press <Enter>. There is no
password.

To undo the changes you've made, exit the emulator (by closing its window),
remove the image file and decompress it again: `rm -f MINIX15.vhd && unzip
-o MINIX15.vhd.zip`.

The HDD disk image contains a single Minix v1 filesystem of size ~64 MiB,
which is the maximum Minix v1 filesystem size, and Minix 1.5.10 doesn't
support any other filesystems.

The official Minix 1.5.10 release supports booting from floppy only. For
booting directly from HDD, the ShoeLace bootloader was used commonly in
1989--1994 (until Minix 1.6.25 came out, which has included its own boot.c).
ShoeLace is not part of Minix, it has to be downloaded
ShoeLace is not part of Minix, it has to be downloaded ([ShoeLace source
code](https://web.archive.org/web/20251203014657id_/https://mirror.math.princeton.edu/pub/oldlinux/Linux.old/bin-src/shoelace.minix-1.0a.tar.Z])),
compiled and installed separately. The image above contains
ShoeLace (for completeness), but it uses something else for booting: the
[mbr_bootlace.nasm](https://github.com/pts/mkfs-bootable-minix1/blob/master/mbr_bootlace.nasm)
bootloader, which is placed in the first 1024 bytes of the HDD image file.
It loads the kernel from the file named `/minix` in the Minix v1 filesystem
on the HDD image file. mbr_bootlace.nasm loads the kernel quickly, while with
ShoeLace it would takes about a second.

The following goodies are included:

* The ShoeLace bootloader (both source and binaries). It's included, but
  it's not in use to boot the system.
* man (manual) pages and the extra manual pages in section 7.
* The convenience *dir* command which does `ls -la | more`.
* The memory size of the *tsort* command has been increased by *chmem*.
* Precompiled kernel component files (bootblok, kernel, mm, fs, init and
  menu). They can be used to boot with ShoeLace, or a new kernel image (file
  `/minix`) can be built from them.

This HDD image with the goodies is a useful starting point for compiling and
installing the unofficial Minix 1.5.10 i386 release by Bruce Evans
(1990-06-11) from source. To just try the final result without recompiling,
use boot option 2 in the section below.

## Running Minix 1.5.10 on Linux in QEMU using the oldlinux.org source

Most of the Minix files with the image are dated between 2003-01-04 and
2003-01-11.

Download the file
[MINIX15.vhd.zip](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v1/MINIX15.vhd.zip)
(`wget -O MINIX15.vhd.zip
https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v1/MINIX15.vhd.zip`),
and decompress it with `unzip -o MINIX15.vhd.zip` or `gunzip -S.zip -fk MINIX15.vhd.zip`.

Optionally, you can inspect the contents of the 4 filesystems:

```
mkdir -p p1 p2 p3 p4
sudo mount -t vfat  -o ro,loop,offset=$((38*512)),sizelimit=$((102714*512)) MINIX15.vhd p1
sudo mount -t minix -o ro,loop,offset=$((103968*512)),sizelimit=$((97280*512)) MINIX15.vhd p2
sudo mount -t minix -o ro,loop,offset=$((201248*512)),sizelimit=$((97280*512)) MINIX15.vhd p3
sudo mount -t minix -o ro,loop,offset=$((298528*512)),sizelimit=$((79040*512)) MINIX15.vhd p4
find p1 p2 p3 p4 -depth -type f
sudo umount p1 p2 p3 p4
```

Install QEMU. On Debian and Ubuntu, the install command is `sudo apt-get
install qemu-system-x86`. The command `qemu-system-i386 --version` should
work. The version number it displays should be >=2.11.1.

Run this command to start the emulator running Minix 1.5.10:
`qemu-system-i386 -M pc-1.0 -m 4 -drive file=MINIX15.vhd,format=vpc -boot c
-debugcon stdio -net none`. (VirtualBox also works, but the VM guest setup
is different.) In the newly appearing QEMU window, at the
`Boot:` prompt, press <2> for Minix 1.5.10 i386, or <4> for Minix
1.5.10 i86. After a few seconds, the `login:` prompt appears. Type `root`
and press <Enter>. There is no password.

To undo the changes you've made, exit the emulator (by closing its window),
remove the image file and decompress it again: `rm -f MINIX15.vhd && unzip
-o MINIX15.vhd.zip`.

## Extra oldlinux.org goodies

The following extra software (in addition to Minix binaries and source code)
are also included:

* On partition 1:
  * MX386/MX386_1.TZ: Minix 1.5.10 i386 patches by Bruce Evans (1990-06-11).
  * MX386/BCC*.TZ: The BCC C compiler (targeting i86 and i386) by Bruce Evans
    (1990-06-11).
  * MX386/SHOELACE.TZ: ShoeLace bootloader 1990-04-24 source code. Can be
    found on other partitions as well.
* On partition 2:
  * bin/sh is Bash 1.05.
  * linux/bash-1.05: Bash 1.05 source code.
  * linux/rootdisk/root-0.11: Linux 0.11 rootdisk binaries.
  * linux/rootdisk/root-0.97: Linux 0.97 rootdisk binaries.
  * linux/src: Linux 0.11, 0.12 and 0.95 source code.
  * root/as86: source code of an early version of the as86 assembler and ld86 linker.
  * root/gcc140: source code of GCC 1.40.
  * root/gdb.tar.Z: Patches and binaries of GDB 3.5 for Minix 1.5.0 i386.
* On partition 3:
  * src/programs/awk: GNU AWK (gawk) 1.02 source code.
  * src/programs/bisn: GNU Bison 1.14 source code.
  * src/programs/bison-1.14: GNU Bison 1.14 source code.
  * src/programs/cpp: GNU C Preprocessor source code.
  * src/programs/gawk: GNU AWK (gawk) 2.11 source code.

## The oldlinux.org source

The MINIX15.vhd HDD image was obtained like this:

```
$ wget -O MINIX15.img.tar.gz https://download.oldlinux.org/MINIX15.img.tar.gz
$ tar xvf MINIX15.img.tar.gz MINIX15.img
$ rm -f MINIX15.img.tar.gz
$ mv MINIX15.img MINIX15.gho
$ perl -x ghost2vhd.pl
$ touch -r MINIX15.gho MINIX15.vhd
```
[oldlinux.org](https://oldinux.org/) claims that this HDD image was the
environment where
Linus Torvalds developed the early versions of Linux (before 1.0). However,
the last-modification timestamps don't confirm this: such early Linux
development has happened before 1994, and the timestamps of the Minix files
on the HDD image are in 2003-01. Nevertheless, the disk image contains some
early source files of Linux 0.11 and 0.97.

The Perl script ghost2vhd.pl was written by reverse engineering the contents
of MINIX15.gho. This file can be converted back (restored) to a disk image
using Norton Ghost 8.0 or 2003. It doesn't work with Norton Ghost 7.5, 9.0
or 11.5. Please note that Norton Ghost, when restoring, moves partitions
around and changes the disk geometry information in FAT filesystem boot
sectors. These changes have been undone manually.

Running ghost2vhd.pl requires only Perl, and it doesn't need Norton Ghost.
