{pkgs, ...}: {
  home.packages = with pkgs; [
    anystyle-cli
    asciidoc-full-with-plugins
    hexyl
    lapce
    mdbook
    tectonic
    texliveFull
    topiary
    tree-sitter
    typst
    typst-live
    typstfmt
    typstyle
    zed-editor
    zotero
  ];
}
