{ config, programs, pkgs, ... }:
{
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
