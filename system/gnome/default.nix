{lib, ...}: {
  imports = [
    ./dconf.nix
  ];

  services.gnome.shell.enable = true;
}
