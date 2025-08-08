{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sequoia-sq
    sequoia-sqop
    sequoia-sqv
    sequoia-wot
  ];
}
