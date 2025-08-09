{pkgs, ...}: {
  home.packages = with pkgs; [
    brotli
    p7zip
    zpaq
    zstd
  ];
}
