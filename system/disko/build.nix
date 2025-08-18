{disko, ...}: {
  disko.devices = {
    disk.big18t = {
      device = "/dev/disk/by-id/ata-ST18000NM000J-2TV103_ZR5260QV"; # whole disk
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          stage = {
            name = "stage";
            size = "1000G";
            content = {
              type = "filesystem";
              format = "xfs";
              extraArgs = ["-L" "STAGE"];
              mountpoint = "/drive/stage";
              mountOptions = [
                "noatime"
                "lazytime"
                "inode64"
                "nofail"
                "x-systemd.automount"
                "x-systemd.idle-timeout=600"
              ];
            };
          };

          cold = {
            name = "cold";
            size = "10000G";
            content = {
              type = "filesystem";
              format = "xfs";
              extraArgs = ["-L" "COLD"];
              mountpoint = "/drive/cold";
              mountOptions = [
                "noatime"
                "inode64"
                "nofail"
                "x-systemd.automount"
                "x-systemd.idle-timeout=600"
              ];
            };
          };

          books = {
            name = "books";
            size = "2500G";
            content = {
              type = "filesystem";
              format = "btrfs";
              extraArgs = ["-L" "BOOKS"];
              mountpoint = "/drive/books";
              mountOptions = [
                "noatime"
                "compress=zstd:15"
                "nofail"
                "x-systemd.automount"
                "x-systemd.idle-timeout=600"
              ];
            };
          };

          caches = {
            name = "caches";
            size = "2000G";
            content = {
              type = "filesystem";
              format = "ext4";
              extraArgs = ["-L" "CACHES"];
              mountpoint = "/drive/caches";
              mountOptions = [
                "noatime"
                "lazytime"
                "commit=30"
                "nofail"
                "x-systemd.automount"
                "x-systemd.idle-timeout=600"
              ];
            };
          };

          scratch = {
            name = "scratch";
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              extraArgs = ["-L" "SCRATCH"];
              mountpoint = "/drive/scratch";
              mountOptions = [
                "noatime"
                "lazytime"
                "inode64"
                "nofail"
                "x-systemd.automount"
                "x-systemd.idle-timeout=600"
              ];
            };
          };
        };
      };
    };
  };
}
