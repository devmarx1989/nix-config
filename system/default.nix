{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./boot.nix
    ./fileSystems.nix
    ./fonts.nix
    ./environment.nix
    ./gnome/default.nix
    ./hardware.nix
    ./hardware-configuration.nix
    ./mount/default.nix
    ./network.nix
    ./nix.nix
    ./nixpkgs.nix
    ./programs/default.nix
    ./security.nix
    ./services/default.nix
    ./systemd.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
