{pkgs, ...}: {
  home.packages = with pkgs; [
    clang
    lld
    lldb
    llvm
    mold
    musl
    yasm
    gcc
    gnumake
    pkg-config
    zlib
    openssl
    libxml2
    libxslt
  ];
}
