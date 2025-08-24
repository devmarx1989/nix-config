{pkgs, ...}: {
  home.packages = with pkgs; [
    languagetool
    languagetool-rust
  ];
}
