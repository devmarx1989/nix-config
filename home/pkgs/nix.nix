{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    nh
    nix-index
    nix-output-monitor
  ];
}
