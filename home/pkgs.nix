{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    clang
    llvm
    lld
    lldb
    curl
    delta
    docker
    docker-compose
    fd
    ffmpeg-full
    fishPlugins.bobthefish
    fishPlugins.foreign-env
    helix
    hexyl
    htop
    mediainfo
    neofetch
    nh
    nix-index
    nix-output-monitor
    nushell
    nushellPlugins.highlight
    pandoc
    ponysay
    pnpm
    rye
    sccache
    wget
  ];

}
