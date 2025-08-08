{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sequoia-sq
    sequoia-sqpop
    sequoia-sqv
    sequoia-wot
  ];
}
