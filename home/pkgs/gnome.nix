{pkgs, ...}: {
  home.packages = with pkgs; [
    dconf
    dconf-editor
    dconf2nix
  ];
}
