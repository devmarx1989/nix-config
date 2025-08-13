{pkgs, ...}: {
  home.packages = with pkgs; [
    git-doc
    gitFull
    gitoxide
    gitui
    jujutsu
    lefthook
    pijul
  ];
}
