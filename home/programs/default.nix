{ config, programs, pkgs, ... }:
{
    imports = [
      ./git.nix
      ./vim.nix
    ];
    programs.home-manager.enable = true;
    programs.fish.enable = true;
}
