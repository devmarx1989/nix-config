{
  systemd,
  fileSystems,
  ...
}: {
  fileSystems."/drive/" = {
    device = "/dev/disk/by-label/drive"; # whole disk
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /drive/ 0777 dev-marx dev-marx -"
  ];
}
