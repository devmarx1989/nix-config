{ config, pkgs, nixvim, ... }:

{
  imports = [
    ./programs/default.nix
  ];
  home.username = "devmarx";
  home.homeDirectory = "/home/devmarx";
  home.shell.enableFishIntegration = true;
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    htop
    bat
    neofetch
    curl
    wget
    fd
  ];
}
