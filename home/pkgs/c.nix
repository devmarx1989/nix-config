{pkgs, ...}: {
  home.packages = with pkgs; [
    clang
    gnumake
    libxml2
    libxslt
    lld
    lldb
    llvm
    mold
    musl
    openssl
    pkg-config
    yasm
    zlib
  ];
}
