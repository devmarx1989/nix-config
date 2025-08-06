{ networking, lib, ... }: {
  networking.useDHCP = lib.mkDefault true;
  networking.nameservers = [ "127.0.0.1#1001" "1.1.1.1" "9.9.9.9" ];
  networking.hostName = "house-of-marx";
  networking.firewall.enable = false;

  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
}

