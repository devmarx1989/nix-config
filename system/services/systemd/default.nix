{
  config,
  pkgs,
  lib,
  services,
  systemd,
  ...
}: {
  imports = [
    ./squid-exporter.nix
  ];
}
