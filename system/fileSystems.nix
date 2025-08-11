{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/65b82857-eed5-42ef-90ed-5b4e580bdda8";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1EA8-B7B6";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/drive" = {
    device = "/dev/disk/by-label/drive";
    fsType = "ntfs3";
    options = ["rw" "uid=1000" "gid=100" "umask=0022" "ignore"];
  };

  fileSystems."/store" = {
    device = "/dev/disk/by-label/store";
    fsType = "ext4";
  };
  swapDevices = [
    {device = "/dev/disk/by-uuid/5f5f32dd-9782-4dd8-b365-10f83c0e446e";}
  ];
}
