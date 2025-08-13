{pkgs, ...}: {
  home.packages = with pkgs; [
    git-annex
    git-doc
    git-extras
    gitoxide
    gitui
    jujutsu
    lefthook
    pijul
  ];
}
