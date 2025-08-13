{pkgs, ...}: {
  home.packages = with pkgs; [
    git-annex
    git-doc
    git-extra
    gitoxide
    gitui
    jujutsu
    lefthook
    pijul
  ];
}
