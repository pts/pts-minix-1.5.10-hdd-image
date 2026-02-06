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
[minix-1.5.10-i86.vhd.zip](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86.vhd.zip):

```
wget -O minix-1.5.10-i86.vhd.zip https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86.vhd.zip
```

, and decompress it with

```
unzip -o minix-1.5.10-i86.vhd.zip
```

or `gunzip -S.zip -fk minix-1.5.10-i86.vhd.zip`.

Optionally, you can inspect the contents of the filesystem:

```
mkdir -p p
sudo mount -t minix -o ro,loop minix-1.5.10-i86.vhd p
find p -depth -type f
ls -ld p/minix
sudo umount p
```

Install QEMU. On Debian and Ubuntu, the install command is `sudo apt-get
install qemu-system-x86`. The command `qemu-system-i386 --version` should
work. The version number it displays should be >=2.11.1.

Run this command to start the emulator running Minix 1.5.10:

```
qemu-system-i386 -M pc-1.0 -m 4 -drive file=minix-1.5.10-i86.vhd,format=vpc -boot c -debugcon stdio -net none -enable-kvm
```

(VirtualBox also works, but the VM guest
setup is different.) In the newly appearing black QEMU window, in less than
a second, at the `login:` prompt, type `root` and press <Enter>. There is no
password.

To undo the changes you've made, exit the emulator (by closing its window),
remove the image file and decompress it again: `rm -f minix-1.5.10-i86.vhd && unzip
-o minix-1.5.10-i86.vhd.zip`.

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
[minix-1.5.10-i86-and-goodies.vhd.zip](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86-and-goodies.vhd.zip):

```
wget -O minix-1.5.10-i86-and-goodies.vhd.zip https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v2/minix-1.5.10-i86-and-goodies.vhd.zip
```

, and decompress it with

```
unzip -o minix-1.5.10-i86-and-goodies.vhd.zip
```

or `gunzip -S.zip -fk minix-1.5.10-i86-and-goodies.vhd.zip`.

Optionally, you can inspect the contents of the filesystem:

```
mkdir -p p
sudo mount -t minix -o ro,loop minix-1.5.10-i86-and-goodies.vhd p
find p -depth -type f
sudo umount p
```

Install QEMU. On Debian and Ubuntu, the install command is `sudo apt-get
install qemu-system-x86`. The command `qemu-system-i386 --version` should
work. The version number it displays should be >=2.11.1.

Run this command to start the emulator running Minix 1.5.10:

```
qemu-system-i386 -M pc-1.0 -m 4 -drive file=minix-1.5.10-i86-and-goodies.vhd,format=vpc -boot c -debugcon stdio -net none -enable-kvm
```

(VirtualBox also works, but the VM guest setup
is different.) In the newly appearing black QEMU window, in less than a
second, at the `login:` prompt, type `root` and press <Enter>. There is no
password.

To undo the changes you've made, exit the emulator (by closing its window),
remove the image file and decompress it again: `rm -f minix-1.5.10-i86-and-goodies.vhd && unzip
-o minix-1.5.10-i86-and-goodies.vhd.zip`.

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

```
wget -O MINIX15.vhd.zip https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v1/MINIX15.vhd.zip
```

, and decompress it with

```
unzip -o MINIX15.vhd.zip
```

or `gunzip -S.zip -fk MINIX15.vhd.zip`.

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

```
qemu-system-i386 -M pc-1.0 -m 4 -drive file=MINIX15.vhd,format=vpc -boot c -debugcon stdio -net none -enable-kvm
```

(VirtualBox also works, but the VM guest setup
is different.) In the newly appearing QEMU window, at the `Boot:` prompt,
press <2> for Minix 1.5.10 i386 on partition 2, or <4> for Minix 1.5.10 i86
on partition 4. After a few seconds, the `login:` prompt appears. Type
`root` and press <Enter>. There is no password.

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

## Running Linux 1.0.4 on Linux in QEMU

[MCC
1.0](https://www.ibiblio.org/pub/historic-linux/distributions/MCC-1.0/1.0/)
is one of the earliest Linux distributions. It was released on 1994-05-11,
it runs on i386, and it contains Linux kernel 1.0.4, GCC 2.5.8, Bash 1.13.1,
`/lib/libc.so.4.5.21`, GNU Assembler 2.2, GNU linker 2.2. It supports the
Minix v1 and ext2 filesystems, and can boot from them.

For your convenience, a preinstalled, ready-to-run MCC 1.0 binary image (no
source code) is provided, based on the official [MCC
1.0](https://www.ibiblio.org/pub/historic-linux/distributions/MCC-1.0/1.0/)
install floppies (1994-05-11)
(kernel compressed floppy [nocdboot](https://www.ibiblio.org/pub/historic-linux/distributions/MCC-1.0/1.0/images/nocdboot.gz),
installer root filesystem compressed floppy [root](https://www.ibiblio.org/pub/historic-linux/distributions/MCC-1.0/1.0/images/root.gz),
GCC compressed floppies [gcca.tgz](https://www.ibiblio.org/pub/historic-linux/distributions/MCC-1.0/1.0/packages/gcca.tgz)
and [gccb.tgz](https://www.ibiblio.org/pub/historic-linux/distributions/MCC-1.0/1.0/packages/gccb.tgz)).
It contains only a few config file changes. The HDD disk image contains a
single, bootable ~64 MiB Minix v1 filesystem on the top level (not in a
partition) with maximum filename length of 30 bytes.

Download the file
[linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd.zip](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v3/linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd.zip):

```
wget -O linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd.zip https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v3/linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd.zip
```

, and decompress it with

```
unzip -o linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd.zip
```

or `gunzip -S.zip -fk linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd.zip`.

Optionally, you can inspect the contents of the filesystem:

```
mkdir -p p
sudo mount -t minix -o ro,loop linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd p
find p -depth -type f
ls -ld p/vmlinuz
sudo umount p
```

Install QEMU. On Debian and Ubuntu, the install command is `sudo apt-get
install qemu-system-x86`. The command `qemu-system-i386 --version` should
work. The version number it displays should be >=2.11.1.

Run this command to start the emulator running Linux 1.0.4:

```
qemu-system-i386 -M pc-1.0 -m 4 -drive file=linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd,format=vpc -boot c -debugcon stdio -net none -enable-kvm
```

(VirtualBox also works, but the VM guest
setup is different.) In the newly appearing black QEMU window, in less than
a second, at the `login:` prompt, type `root` and press <Enter>. There is no
password.

To undo the changes you've made, exit the emulator (by closing its window),
remove the image file and decompress it again: `rm -f linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd && unzip
-o linux-1.0.4-mcc-1.0-i386-and-gcc-2.5.8.vhd.zip`.

The HDD disk image contains a single Minix v1 filesystem of size ~64 MiB,
which is the maximum Minix v1 filesystem size, and Minix 1.5.10 doesn't
support any other filesystems. Linux 1.0.4 (and MCC) supports much larger
ext2 filesystems (even larger than ~504 MiB). If you need that, install MCC
from the official floppies (see above), and choose ext2 when prompted.

The HDD disk image uses the
[mbr_bootlace.nasm](https://github.com/pts/mkfs-bootable-minix1/blob/master/mbr_bootlace.nasm)
bootloader for booting, which is placed in the first 1024 bytes of the HDD
image file. It loads the Linux kernel from the file named `/vmlinuz` in the
Minix v1 filesystem on the HDD image file. Vanilla MCC 1.0 and most other
Linux distributions of the time used the
[LILO](https://en.wikipedia.org/wiki/LILO_(bootloader)) bootloader
([GRUB](https://en.wikipedia.org/wiki/GNU_GRUB) development started in 1995,
and GRUB became widespread by 1999).
mbr_bootlace.nasm is smaller and starts loading the kernel image earlier,
because it doesn't wait for a user keypress.

If you don't need GCC (or the assembler or the linker), download the
somewhat smaller file
[linux-1.0.4-mcc-1.0-i386.vhd.zip](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/v3/linux-1.0.4-mcc-1.0-i386.vhd.zip)
instead.

About the executable formats supported by MCC 1.0:

* `gcc -s -O2 -W -Wall -Werror` creates a dynamically linked
  (`/lib/libc.so.4.5.21`) a.out ZMAGIC (MCC 1.0 *file* says: OMAGIC)
  executable by default.
* `gcc -s -O2 -W -Wall -Werror -static` creates a statically linked a.out
  ZMAGIC (MCC 1.0 *file* says: OMAGIC) executable by default. This is not
  the same as the a.out format used by Minix i386.
* Even though the supplied Linux 1.0.4 kernel can run them, the linker is not able to create [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)-32 executables.
* It's complicated to create shared libraries (such as
  `/lib/libc.so.4.5.21`), because there is no compiler support for
  position-independent code, so the virtual address space for the library
  has to be allocated globally on the system: e.g. *ls* and *find* expect
  the *opendir* libc function to be at the same virtual address.

Linux has never been released for the i86 or any 16-bit architecture. The
very first architecture supported by Linux was the i386, and then many
32-bit and 64-bit architectures followed.
[ELKS](https://github.com/ghaerr/elks) is an early fork of Linux (first
release: ELKS 0.0.63, released on 1997-08-08) for the i86.

A comparison of Minix 1.5.10--2.0.4 i386 to Linux 1.0.4 i386:

* Minix 1.5.10 supports the Minix v1 filesystem, Minix >=1.6.25 supports the
  Minix v1 and Minix v2 filesystems. Linux 1.0.4 supports many filesystems
  including Minix v1 (but not Minix v2), ext2, FAT (but no FAT32 or long
  filenames), ISO9660 (on CD-ROMs, with the Rock Ridge extensions), NFS and
  proc (`/proc`).
* Minix supports Minix v1 and v2 filesystems created with maximum filename
  length 14. Linux supports Minix v1 filesystems created with maximum
  filename length either 14 or 30.
* Linux is much faster in QEMU, probably because of better block caching.
* The Linux 1.0.4 i386 kernel image (i.e. the code and data that remains in
  memory, without .bss) is much larger than the Minix 1.5.10 i86 and i386
  kernel: ~712 KiB uncompressed vs 75.52 KiB (without symbols) vs 93.94 KiB.
  The C compilers used: GCC (optimizing) vs ACK 3.1 (optimizing) vs BCC
  (non-optimizing).
* The Linux kernel uses more memory than the Minix kernel.
* Linux uses more memory per process than Minix.
* Linux supports virtual memory and swapping, Minix doesn't. (The Minix
  1.6.25 fork [Minix-386vm](https://ftp.funet.fi/pub/minix/Minix-386vm/) and
  the Minix 1.7.0 fork
  [Minix-vmd](https://web.archive.org/web/20250710222725/http://www.Minix-vmd.org/)
  do though.)
* Linux supports growing the memory available to a running process (using
  both the sbrk(2) and mmap(2) system calls), Minix doesn't. On Minix, the
  *a_total* field of the a.out header determines the maximum (same as the
  minimum) available memory to a process. This can be changed after linking
  in the executable program file, but it's not possible to change it for a
  process which has already started.
* MCC 1.0 feels much more convenient to use than Minix 1.5.10, partially
  because of the command-line editing and history of the Bash shell (also
  available for Minix i386), and because Linux provides multiple text
  editors (Minix provides *vi* only).
* Both Linux and Minix supports sharing code (in the .text section) between
  multiple processes of the same executable program file.
* Linux and supports sharing read-only data and read-write data between
  multiple processes of the same executable program file, by default, using
  copy-on-write pages. On Minix, data sections are always unshared.
* Linux provides the `/proc` filesystem for inspecting the state of
  processes and the kernel. Minix doesn't provide such a filesystem.

The reverse-historical perspective of Linux vs Minix is the following.
Modern Linux distributions (in 2026) contain tons of application software by
thousands of maintainers, developers and contributors in addition to the
Linux kernel. MCC is one of the earliest Linux distributions containing
precompiled applications (such as text editors, GCC, other developer tools,
GNU troff, GNU Emacs, *mail* e-mail client, *lp* print spoller). MCC 1.0
(1994-05-11) contains the Linux kernel 1.0.4 (1994-03-22), which is mostly a
bugfix release over the Linux kernel 1.0 (1994-03-13), which is an evolution
of the earliest Linux kernels (with 0.03 in 1991-10, 0.11 in 1991-12, 0.12
on 1992-01-15, 0.95 on 1992-03-07, 0.98 on 1992-09-29), which were developed
by Linus Torvalds using GCC 1... as a cross-compiler on a Minix 1.5.10 i386
system (1990-06-15), which was a community port by Bruce Evans of Minix
1.5.10 i86 (1990-06-01), which is an evolution of Minix 1.0 (1987-01-08) by
Andrew Stuart Tanenbaum.

[SLS-1992.11](https://github.com/oldlinux-web/oldlinux-files/blob/master/distributions/SLS/sls-1992.11.zip)
(released on 1992-11-05) is an even earlier Linux distribution than MCC. It
contains Linux kernel 0.98.1 (1992-10-04), Bash 1.12, GCC 2.2.2d, GNU
assembler 1.38, GNU linker 1.38 and X386 2.0 providing X11 GUI. See
[oldinux.org](https://oldlinux.org/) for details of some Linux kernels and
distributions released in 1991 and 1992.

## The partial story of Minix 1.5.10 i386

Minix 1.5.10 i86 (for the Intel 8086 CPU, with ability to use up to 16 MiB
of memory on 286+) was officially released on 1990-06-01 (see [Minix 1.5.10
i86 official
download](http://download.minix3.org/previous-versions/Intel-1.5/)). It
contained the kernel (both source code and binaries), the commands (both
source code and binaries) and configuration files. The source code of the
custom-modified ACK C compiler (/usr/lib/cpp, /usr/lib/cem, /usr/lib/opt,
/usr/lib/cg), the assembler (/usr/bin/asld) and the linker (also
/usr/bin/asld) was missing, but the soure code of the C compiler driver
(/usr/bin/cc, it just runs the others) and the source code of the C library
(i.e. libc) were included.

Most of Minix 1.5.10 (and earlier versions) has been written by Andrew S.
Tanenbaum (with contributions from others) and copyright Prentical Hall (a
publishing company defunct since 2020), so Minix had been proprietary
software in the 1980s and 1990s. Prentice Hall has also published multiple
educational (paper) books written by Andrew S. Tanenbaum about operating
systems in general and Minix in particular. Buyers of some of these books
also got automatically a license to use Minix, but they only had a printed
copy of the source code, and they didn't get the C compiler. Buyers of some
of these books got a discount when purchasing the Minix install floppies.
The install floppies also contained the full source code of the Minix
kernel, commands and C library, but it didn't contain the source code of the
C preprocessor, the C compiler frontend, the C compiler backend and the
assembler--linker.

The most influential book, Operating Systems: Design and Implementation*,
*co-authored by Albert S.
Woodhull, published in 1987 by Prentice Hall includes the source code of
Minix 1.0 i86. Between 1988 and 1990, multiple Minix reference manual books
have been written by Andrew S. Tanenbaum, and published by Prentice Hall.
None of the books mentioned in this paragraph are freely available for
download in 2025. However, Minix
was released as open source under the 3-clause BSD license on 2000-04-07,
applying retroactively to versions released earlier as well, see the
[announcement](https://web.archive.org/web/20250726134343/https://minix1.woodhull.com/faq/mxlicense.html).

The document *Reference Manual for the
Minix 1.5 Demonstration Disk* (1991)
[demoman.pdf](https://web.archive.org/web/20230531061144/https://www.pliner.com/macminix/documentation/demoman.pdf)
is available as a separate download. It has many chapters missing, such as
the install instructions.

There had been no official Minix 1.5.x i386 or Minix 1.6.x release (with
userspace programs using the i386 32-bit protected mode instruction set and
being able to use more than 64 KiB of data per process) by Andrew S.
Tanenbaum (or other Minix authors) so far. [Minix
1.7.0](http://download.minix3.org/previous-versions/Intel-1.7/) was released
for both i86 and i386 on 1995-05-30. However, there have been unofficial
ports by the community: Minix 1.5.10 has been ported (from i86) to i386 by
Bruce Evans, and Minix 1.6.25 has been also been ported to i386 by Kees J.
Bot and Philip Homburg (as Minix-386vm 1.6.25.1), and later they also
published Minix-vmd 1.7.0, which is also a port to the i386, based on Minix
1.7.0 i386 and all other earlier work above. Minix-386vm and Minix-vmd add
virtual memory support (including swapping and larger virtual address spaces
for processes), better memory protection and official X11 (GUI) support.

The first (still unofficial, community-maintained) port of Minix to i386 was
Minix 1.5.10 i386 by Bruce Evans, released between 1990-06-14 and
1990-07-11, only a few days after the official Minix 1.5.10 i86 release. It
consisted of the following files:

|   size|date       |filename |description |
|-------|-----------|---------|------------|
|  12063|1990-06-14|[bcc.tar.Z](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/minix-1.5.10-i386-patches/bcc.tar.Z)             |source file bcc.c, the C compiler driver|
| 121962|1990-06-15|[bccbin16.tar.Z](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/minix-1.5.10-i386-patches/bccbin16.tar.Z)   |BCC C compiler, assembler and linker binaries running on Minix 1.5.10 i86,  targeting Minix 1.5.10 i86 and i386|
| 118254|1990-06-15|[bccbin32.tar.Z](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/minix-1.5.10-i386-patches/bccbin32.tar.Z)   |BCC C compiler, assembler and linker binaries running on Minix 1.5.10 i386, targeting Minix 1.5.10 i86 and i386|
|  43492|1990-06-15|[bcclib.tar.Z](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/minix-1.5.10-i386-patches/bcclib.tar.Z)       |C library (libc) source code and /usr/include fixes for Minix 1.5.10 i86 and i386|
|  45155|1990-06-15|[mx386_1.1.t.Z](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/minix-1.5.10-i386-patches/mx386_1.1.t.Z)     |kernel source patches for Minix 1.5.10 i86 to change it to i386|
|   3623|1990-07-11|[mx386_1.1.01.Z](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/minix-1.5.10-i386-patches/mx386_1.1.01.Z)   |bugfix kernel source patches for Minix 1.5.10 i386|

In 2025-11, the files above were not available for download anymore, so I've
re-uploaded them as
[https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/tag/minix-1.5.10-i386-patches](minix-1.5.10-i386-patches).

Because of licensing reasons, it was not allowed for the community to
release installer floppy images with precompiled binaries of Minix 1.5.10
i386, because Prentice Hall owned the copyright of Minix 1.5.10. Thus Minix
1.5.10 i386 was released as the files above, which contained some new
binaries and source code patches to Minix 1.5.10 i86. On 1990-12-03, John
Nall wrote the tutorial
[tutor.asc](https://github.com/pts/pts-minix-1.5.10-hdd-image/releases/download/minix-1.5.10-i386-patches/tutor.asc)
on creating a Minix 1.5.10 i386 system based on an already installed Minix
1.5.10 i86 system and the files above released by Bruce Evans.

The reason why a new C compiler was needed for Minix 1.5.10 i386 is that the
modified ACK C compiler in Minix 1.5.10 i86 didn't support the i386 target
instruction set. The vanilla [ACK C compiler](https://tack.sf.net/) has
already supported the i386 target instruction set in 1991-09-18, but ACK was
open sourced much later, in 2003-04 under the 3-clause BSD license, so it
couldn't be used in 1990-06 for porting Minix. Bruce Evens has already
written his C compiler BCC. Please note that BCC is a non-optimizing
compiler, so it generates long and slow code. (An optimizer has been added
later, but the stability of the i386 optimizer output is unclear.)

The source code of the BCC C compiler targeting Minix 1.5.10 i86 and i386
has never been released. Bruce Evans continued releasing new versions of the
BCC C compiler as part of [Dev86](https://github.com/lkundrak/dev86),
targeting both i86 and i386 (selectable by a command-line flag). Bruce Evans
continued releasing new versions of the assembler and the linker as well,
first as part of as86, then within Dev86. The source code of the linker
which can read the Minix 1.5.10 ar .a archive format (such as
/usr/local/lib/i386/libc.a) has never been released.

## C compilers in early Minix versions

* Minix 1.5.10 i86: ACK.
* The unofficial, community-maintained Minix 1.5.10 i386: BCC.
* Minix-386vm 1.6.25.1 i386: BCC (bcc command), GCC (gcc command), C386 (ccc command).
* Minix 1.7.0 i86 and i386: ACK.
* Minix-vmd 1.7.0 i386: ACK, GCC.
