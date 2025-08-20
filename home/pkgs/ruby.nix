{pkgs, ...}: {
  home.packages = with pkgs; [
    ruby_3_4
    rubyfmt
    ruby-lsp
  ];
}
