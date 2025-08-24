{
  config,
  networking,
  lib,
  ...
}: let
  squid = toString config.my.ports.squidProxy;
in {
  networking = {
    useDHCP = lib.mkDefault true;
    nameservers = ["127.0.0.1"];
    hostName = "house-of-marx";
    firewall.enable = false;
    # Enable IPv6 stack so Squid can bind [::] quietly
    enableIPv6 = true;

    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    proxy = {
      default = "http://127.0.0.1:${squid}";
      #noProxy = "localhost,127.0.0.1,::1,*.local";
    };
    # Enable networking
    networkmanager.enable = true;
    nftables.enable = true;
  };
}
