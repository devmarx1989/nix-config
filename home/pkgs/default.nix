{ pkgs, ... }:
{
  imports = [
    ./ai.nix
    ./anime.nix
    ./api.nix
    ./c.nix
    ./db.nix
    ./media.nix
    ./myPkgs.nix
    ./mpv.nix
    ./network.nix
    ./nix.nix
    ./pkg.nix
    ./python.nix
    ./sec.nix
    ./sim.nix
    ./terminal.nix
    ./text.nix
  ];
  home.packages = with pkgs; [
    cacert
    cachix
    calibre
    cointop
    coursier
    docker
    docker-compose
    fishPlugins.bobthefish
    fishPlugins.foreign-env
    microsoft-edge
    monaspace
    nickel
    nushell
    nushellPlugins.highlight
    nyancat
    pandoc
    pnpm
    sccache
    stack
    tiv
    translate-shell
    translatelocally
    wl-clipboard-x11
  ];

}
