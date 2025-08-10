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
    ./hardware.nix
    ./hardware-configuration.nix
    ./network.nix
    ./nix.nix
    ./nixpkgs.nix
    ./programs.nix
    ./security.nix
    ./services/default.nix
    ./systemd.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
