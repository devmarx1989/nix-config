{virtualisation, ...}: {
  # Graphics drivers
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  virtualisation.waydroid.enable = true;
}
