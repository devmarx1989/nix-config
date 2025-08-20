{pkgs, ...}: {
  home.packages = with pkgs; [
    anystyle-cli
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
