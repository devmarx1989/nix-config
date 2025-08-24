{pkgs, ...}: {
  home.packages = with pkgs; [
    ctranslate2
    deep-translator
    gtt
    haskellPackages.translate-cli
    languagetool
    libretranslate
    translate-shell
    translatelocally
    translatepy
  ];
}
