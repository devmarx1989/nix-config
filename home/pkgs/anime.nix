{ pkgs, ... }:
{
  home.packages = with pkgs; [
    animdl
    anime4k
    gallery-dl
    hakuneko
  ];
}
