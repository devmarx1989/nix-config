{pkgs, ...}: {
  home.packages = with pkgs; [
    dpkg
    pacman
    pixi
    yay
  ];
}
