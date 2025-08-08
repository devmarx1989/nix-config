{ pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    agebox
    feroxbuster
    gopass
    sequoia-sq
    sequoia-sqop
    sequoia-sqv
    sequoia-wot
    sn0int
    sniffglue
    wordlists
    xxHash
  ];
}
