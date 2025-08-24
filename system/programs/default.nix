{
  config,
  programs,
  pkgs,
  ...
}: {
  imports = [
    ./steam/default.nix
  ];

  programs = {
    adb.enable = true;
    ccache.enable = true;
    dconf.enable = true;
    fish.enable = true;
    mtr.enable = true;
    nix-ld.enable = true;
    firefox.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
