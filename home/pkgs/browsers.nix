{pkgs, ...}: {
  home.packages = with pkgs; [
    lagrange
    microsoft-edge
    palemoon-bin
    w3m
  ];
}
