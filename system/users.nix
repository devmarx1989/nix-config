{
  users,
  pkgs,
  lib,
  ...
}: let
  user = "dev-marx";
in {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.${user} = {};

  users.users.${user} = {
    description = "/dev/marx";
    enable = true;
    extraGroups = [
      "audio"
      "avahi"
      "calibreWeb"
      "calibre"
      "docker"
      "ipfs"
      "jellyfin"
      "networkmanager"
      "ollama"
      "postgresql"
      "render"
      "squid"
      "video"
      "wheel"
      "wireshark"
    ];
    group = user;
    home = "/home/dev-marx";
    isNormalUser = true;
    shell = pkgs.fish;
    packages = with pkgs; [
      #  thunderbird
    ];
  };
}
