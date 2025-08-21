{
  config,
  programs,
  pkgs,
  ...
}: {
  imports = [
    ./steam/default.nix
  ];

  programs.dconf.enable = true;
  programs.ccache.enable = true;
  programs.nix-ld.enable = true;
  programs.mtr.enable = true;
  programs.fish.enable = true;
  # Install firefox.
  programs.firefox.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
