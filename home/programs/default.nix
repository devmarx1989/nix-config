{ config, programs, pkgs, ... }:
{
    imports = [
      ./git.nix
      ./vim.nix
    ];
    programs.home-manager.enable = true;
    programs.fish = {
      enable = true;
      interactiveShellInit = "
      if status is-interactive
        fish_vi_key_bindings
        fortune -a -e | ponysay 
      end
      ";
  };
  programs.nix-ld.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
