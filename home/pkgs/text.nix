{pkgs, ...}: {
  home.packages = with pkgs; [
    lapce
    tectonic
    texliveFull
    topiary
    hexyl
    tree-sitter
    typst
    typst-live
    typstfmt
    typstyle
    zotero
    zed-editor
  ];
}
