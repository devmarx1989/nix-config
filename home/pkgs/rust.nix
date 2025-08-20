{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    cargo-watch
    cargo-c
    cargo-bump
    cargo-bootimage
  ];
}
