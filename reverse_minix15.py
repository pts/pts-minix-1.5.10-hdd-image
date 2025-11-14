#! /usr/bin/python2

"""reverse_minix15.py: reverse-engineer MINIX15.gho"""

import struct
import sys


def main(argv):
  # CHS=685:16:38
  # required: 621:16:38
  # QEMU: 622:16:38
  #
  # $ fdisk -l 'Ghost HDD.vhd'
  # Disk Ghost HDD.vhd: 500 MiB, 524288512 bytes, 1024001 sectors
  # Units: sectors of 1 * 512 = 512 bytes
  # Sector size (logical/physical): 512 bytes / 512 bytes
  # I/O size (minimum/optimal): 512 bytes / 512 bytes
  # Disklabel type: dos
  # Disk identifier: 0x28c528c4
  # Device         Boot  Start    End Sectors  Size Id Type
  # Ghost HDD.vhd1 *        63 102815  102753 50.2M  6 FAT16
  # Ghost HDD.vhd2      104832 202607   97776 47.8M 81 Minix / old Linux
  # Ghost HDD.vhd3      202608 300383   97776 47.8M 81 Minix / old Linux
  # Ghost HDD.vhd4      300384 380015   79632 38.9M 81 Minix / old Linux

  # $ fdisk -l MINIX15.gho.s0.bin
  # Disk MINIX15.gho.s0.bin: 512 B, 512 bytes, 1 sectors
  # Units: sectors of 1 * 512 = 512 bytes
  # Sector size (logical/physical): 512 bytes / 512 bytes
  # I/O size (minimum/optimal): 512 bytes / 512 bytes
  # Disklabel type: dos
  # Disk identifier: 0x00000000
  # Device              Boot  Start    End Sectors  Size Id Type
  # MINIX15.gho.s0.bin1 *        38 102751  102714 50.2M  6 FAT16
  # MINIX15.gho.s0.bin2      103968 201247   97280 47.5M 81 Minix / old Linux
  # MINIX15.gho.s0.bin3      201248 298527   97280 47.5M 81 Minix / old Linux
  # MINIX15.gho.s0.bin4      298528 377567   79040 38.6M 81 Minix / old Linux

  ad = open('Ghost HDD.vhd', 'rb').read()
  gd = open('MINIX15.gho', 'rb').read()

  # of.write(gd[0xa0a : 0xa0a + 0x200]) # MBR.
  gi = oi = 0
  for ar, ok, xd in ((xrange(0, 38), 0, 2570),
                     (xrange(63, 102815 + 1 - 39), 38, 3112),
                     (xrange(104832, 202607 + 1 - 496), 103968, 4196),
                     (xrange(202608, 300383 + 1 - 496), 201248, 4738),
                     (xrange(300384, 380015 + 1 - 592), 298528, 5280)):
    for ai in ar:
      if oi == 102752 and ok == 103968:
        oi = ok  # !! Add this many NUL bytes.
      assert oi == ok, (oi, ok)
      if ai == 0:  # MBR modified by Norton Ghost 9.0.
        gj = 0xa0a
      elif ai == 63:  # FAT boot sector modified by Norton Ghost 9.0.
        gj = 0x5828
      elif ai == 202608:
        gj = 103043267 + 447
      elif ai == 202609:
        gj = 103043779 + 447
      else:
        data = ad[ai << 9 : (ai + 1) << 9]
        #print((data,)); return
        assert len(data) == 0x200
        gj = gd.find(data, gi)
      assert gj >= gi, (ai, gi)
      if gj >= gi:
        d = gj - (ok << 9)
        if d != xd:
          print (ai, gj, d, xd)
        #assert d == xd, (ai, gi, d, xd)
        if 0:
          print([ai, d])
      if gj >= gi:
        gi = gj + 0x200
      ok += 1
      oi += 1

if __name__ == '__main__':
  sys.exit(main(sys.argv))
