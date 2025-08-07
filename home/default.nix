{ config, pkgs, nixvim, ... }:

{
  imports = [
    ./alias.nix
    ./path.nix
    ./pkgs.nix
    ./programs/default.nix
    ./vars.nix
  ];
  home.username = "dev-marx";
  home.homeDirectory = "/home/dev-marx";
  home.shell.enableFishIntegration = true;
  home.stateVersion = "25.05";
}
