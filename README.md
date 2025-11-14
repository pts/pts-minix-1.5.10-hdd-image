# pts-minix1.5-hdd-image: bootable HDD image of Minix 1.5.10 i86 and i386

pts-minix1.5-hdd-image provides bootable HDD disk image containing Minix
1.5.10 i86 and i386. It works in QEMU >=2.11.1, VirtualBox and possibly
other emulators.

Most of the Minix files are dated between 2003-01-04 and 2003-01-11.

## Instructions for runnig it on Linux in QEMU

Download the file MINIX15.vhd.zip and uncompress it with `unzip MINIX15.vhd.zip`.

Optionally you can inspect the contents of the 4 filesystems.

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

Run this command to start the emulator:
`qemu-system-i386 -M pc-1.0 -m 4 -drive file=MINIX15.vhd,format=raw -boot c
-debugcon stdio -net none`. At the newly appearing `Boot:` prompt, press <2>
for Minix 1.5.10 i386, or <4> for Minix 1.5.10 i86. After a few seconds,
the `login:` prompt appears. Type `root` and press <Enter>. There is no
password.

To undo the changes you've made in the emulator, remove the image file and
uncompress it again: `rm -f MINIX15.vhd && unzip MINIX15.vhd.zip`.

## Source

The HDD image was obtained like this:

```
$ wget -O MINIX15.img.tar.gz https://download.oldlinux.org/MINIX15.img.tar.gz
$ tar xvf MINIX15.img.tar.gz MINIX15.img
$ rm -f MINIX15.img.tar.gz
$ mv MINIX15.img MINIX15.gho
$ perl -x ghost2vhd.pl
$ touch -r MINIX15.gho MINIX15.vhd
```
https://oldinux.org/ claims that this HDD image was the environment where
Linus Torvalds developed the early versions of Linux (before 1.0). However,
the last-modification timestamps don't confirm this: such early Linux
development was happened before 1994, and the timestamps of the Minix files
on the HDD image are in 2003-01. Nevertheless, the disk image contains some
early source files of Linux 0.11 and 0.97.

The Perl script ghost2vhd.pl was written by reverse engineering the contents
of MINIX15.gho. This file can be converted back (restored) to a disk image
using Norton Ghost 8.0 or 2003. It doesn't work with Norton Ghost 7.5, 9.0
or 11.5. Please note that Norton Ghosts, when restoring, moves partitions
around and changes the disk geometry information in FAT filesystem boot
sectors. These changes have been undone manually.

Running ghost2vhd.pl requires only Perl, and it doesn't need Norton Ghost.
