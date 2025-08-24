{pkgs, ...}: {
  home.packages = with pkgs; [
    anystyle-cli
    asciidoc-full-with-plugins
    hexyl
    lapce
    mdbook
    mdbook-d2
    mdbook-epub
    mdbook-graphviz
    mdbook-man
    mdbook-pdf
    mdbook-toc
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
