{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang
    lld
    lldb
    llvm
    musl
  ];
}
