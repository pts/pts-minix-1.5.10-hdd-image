#!/bin/sh --
eval 'PERL_BADLANG=x;export PERL_BADLANG;exec perl -x "$0" "$@";exit 1'
#!perl  # Start marker used by perl -x.
+0 if 0;eval("\n\n\n\n".<<'__END__');die$@if$@;__END__

#
# ghost2vhd.: convert MINIX15.gho to MINIX15.vhd
# by pts@fazekas.hu at Fri Nov 14 01:59:04 CET 2025
# 

BEGIN { $ENV{LC_ALL} = "C" }  # For deterministic output. Typically not needed. Is it too late for Perl?
BEGIN { $ENV{TZ} = "GMT" }  # For deterministic output. Typically not needed. Perl respects it immediately.
BEGIN { $^W = 1 }  # Enable warnings.
use integer;
use strict;

die(1) if !open(FI, "< MINIX15.gho");  # Can be restored with Norton Ghost 8.0 (but not 7.5) and Norton Ghost 2003.
binmode(FI);
die(2) if !open(FO, "> MINIX15.vhd");  # Works both in QEMU (both as format=raw and format=vpc) and VirtualBox.
binmode(FO);
my $cur_sector_idx = 0;
# Reverse engineered sector numbers with /etc/passwd starting.
my %root_passwd_sectors = map { $_ => 1 } qw(106154 141654 202566 302840 316708 318838);

sub copy_sectors($$$) {
  my($sector_idx, $sector_count, $fofs_diff) = @_;
  die(3) if $cur_sector_idx != $sector_idx;
  die(4) if $sector_count < 0;
  $cur_sector_idx += $sector_count;
  my $data;
  for (; $sector_count--; ++$sector_idx) {
    my $fofs = ($sector_idx << 9) + $fofs_diff;
    my $got = sysseek(FI, $fofs, 0);
    die(5) if !$got or $got != $fofs;
    die(6) if (sysread(FI, $data, 0x200) or 0) != 0x200;
    # Make `root' be able to log in without a password.
    die(14) if exists($root_passwd_sectors{$sector_idx}) and $data !~ s@^root:[^:\s]{13}:0:0::/:\n@root::0:0::/:\n------------\n@;
    die(7) if (syswrite(FO, $data, 0x200) or 0) != 0x200;
  }
}

sub write_nul_sectors($$) {
  my($sector_idx, $sector_count) = @_;
  die("fatal: 8: $cur_sector_idx vs $sector_idx\n") if $cur_sector_idx != $sector_idx;
  die(9) if $sector_count < 0;
  $cur_sector_idx += $sector_count;
  my $data = "\0" x 0x200;
  while ($sector_count--) {
    die(10) if (syswrite(FO, $data, 0x200) or 0) != 0x200;
  }
}

sub write_sectors($$) {
  my($sector_idx, $data) = @_;
  die(11) if $cur_sector_idx != $sector_idx;
  die(12) if length($data) & 0x1ff;
  if (length($data)) {
    $cur_sector_idx += length($data) >> 9;
    die(13) if (syswrite(FO, $data, length($data)) or 0) != length($data);
  }
}

# The $sector_idx, $sector_count and $fofs_diff values below have been
# reverse engineered manually by analyzing MINIX15.gho.
copy_sectors(0, 38, 2570);  # MBR and gap in front of partition 1.
copy_sectors(38, 102714, 3112);  # Partition 1 (FAT16).
write_nul_sectors(102752, 1216);  # Gap in front of partition 2.
copy_sectors(103968, 97280, 4196);  # Partition 2 (Minix), bootable Minix 1.5 i386.
copy_sectors(201248, 97280, 4738);  # Partition 3 (Minix), non-bootable.
copy_sectors(298528, 79040, 5280);  # Partition 4 (Minix), bootable Minix 1.5 i86.
write_nul_sectors(377568, 16 * 38);  # Final gap to work around buggy QEMU 2.11.1 int 13h AH==08h.

my($cylinders, $heads, $sectors_per_track) = (622, 16, 38);
my $vhd_size = ($cylinders * $heads * $sectors_per_track) << 9;
# It's possible to have VHD disk images larger than ~504 MiB, but there
# are many compatibility issues, so we don't support creating those here.
die("fatal: device has too many cylinders for compatible VHD: $cylinders\n") if $cylinders > 1024;
$vhd_size += 0xfffff;
$vhd_size &= ~0xfffff;  # Round up to the nearest MiB, as required by Microsoft Azure.
my $uuid = "MINIX15-386Linus";  # Must be 16 bytes.
my $vhd_footer = pack("a8N5a4Na4N4nCCNNa16",
    "conectix", 2, 0x10000, -1, -1, 0, "vpc ", 0x50003, "Wi2k", 0, $vhd_size, 0, $vhd_size, $cylinders, $heads, $sectors_per_track, 2, 0, $uuid);
{ my $checksum = -1;
  for (my $i = 0; $i < length($vhd_footer); ++$i) { $checksum -= vec($vhd_footer, $i, 8) }
  substr($vhd_footer, 0x40, 4) = pack("N", $checksum);
}
$vhd_footer .= "\0" x (0x200 - length($vhd_footer));
write_sectors(378176, $vhd_footer);

__END__
