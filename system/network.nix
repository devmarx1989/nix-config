{
  config,
  networking,
  lib,
  ...
}: 
let
  dns = toString config.my.ports.coredns;
in
{
  networking.useDHCP = lib.mkDefault true;
  networking.nameservers = ["127.0.0.1#${dns}" "1.1.1.1" "9.9.9.9"];
  networking.hostName = "house-of-marx";
  networking.firewall.enable = false;
  # Enable IPv6 stack so Squid can bind [::] quietly
  networking.enableIPv6 = true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;
}
