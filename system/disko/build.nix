{disko, ...}: {
  disko.devices = {
    disk.big18t = {
      device = "/dev/disk/by-label/drive"; # whole disk
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          big = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/drive/";
              mountOptions = [
                "noatime"
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
