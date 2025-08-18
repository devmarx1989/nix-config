{
  config,
  lib,
  pkgs,
  ...
}: {
  fileSystems."/drive/books" = {
    device = "/dev/disk/by-partlabel/disk-big18t-books";
    fsType = "btrfs";
    options = ["noatime" "compress=zstd:15" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600"];
  };

  fileSystems."/drive/caches" = {
    device = "/dev/disk/by-partlabel/disk-big18t-caches";
    fsType = "ext4";
    options = ["noatime" "lazytime" "commit=30" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600"];
  };

  fileSystems."/drive/cold" = {
    device = "/dev/disk/by-partlabel/disk-big18t-cold";
    fsType = "xfs";
    options = ["noatime" "inode64" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600"];
  };

  fileSystems."/drive/scratch" = {
    device = "/dev/disk/by-partlabel/disk-big18t-scratch";
    fsType = "xfs";
    options = ["noatime" "lazytime" "inode64" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600"];
  };

  fileSystems."/drive/stage" = {
    device = "/dev/disk/by-partlabel/disk-big18t-stage";
    fsType = "xfs";
    options = ["noatime" "lazytime" "inode64" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600"];
  };

  systemd.tmpfiles.rules = [
    "d /drive/books 0755 dev-marx dev-marx -"
    "d /drive/caches 0755 dev-marx dev-marx -"
    "d /drive/cold 0755 dev-marx dev-marx -"
    "d /drive/scratch 0755 dev-marx dev-marx -"
    "d /drive/stage 0755 dev-marx dev-marx -"
  ];
}
