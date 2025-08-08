{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tectonic
    texliveFull
    topiary
    hexyl
    tree-sitter
    typst
    typst-live
    typstfmt
    typstyle
    zed-editor
  ];
}
