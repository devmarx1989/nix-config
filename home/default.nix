{ config, pkgs, nixvim, ... }:

{
  imports = [
    ./alias.nix
    ./path.nix
    ./pkgs.nix
    ./programs/default.nix
    ./vars.nix
  ];
  home.username = "devmarx";
  home.homeDirectory = "/home/devmarx";
  home.shell.enableFishIntegration = true;
  home.stateVersion = "24.11";
}
