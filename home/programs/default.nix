{
  config,
  programs,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./vim.nix
  ];
  programs.dconf.enable = true;
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
}
