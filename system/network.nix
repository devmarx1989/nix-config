{ config, lib, ... }: {
  networking.useDHCP = lib.mkDefault true;
  networking.nameservers = [ "127.0.0.1" "1.1.1.1" "9.9.9.9" ];
  networking.hostName = "houseofmarx";
  networking.firewall.enable = false;

  # Don't use NetworkManager in WSL
  networking.networkmanager.enable = false;
}

