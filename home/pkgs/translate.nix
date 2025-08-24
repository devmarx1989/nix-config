{pkgs, ...}: {
  home.packages = with pkgs; [
    ctranslate2
    deep-translator
    gtt
    languagetool
    libretranslate
    translate-shell
    translatelocally
    translatepy
  ];
}
