{disko, ...}: {
  disko.devices = {
    disk.big18t = {
      device = "/dev/disk/by-id/ata-ST18000NM000J-2TV103_ZR5260QV"; # whole disk
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          big = {
            size = "100%";
            type = "primary";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/drive/";
              mountOptions = [
                "noatime"
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
