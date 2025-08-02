{ services, ...}:
{
  services.bind = {
    enable = true;
    listenOn = [
      "::1"
      "127.0.0.1"
      "localhost"
    ];

    listenOnIpv6 = [ "::1" ];
    forwarders = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
    cacheNetworks = [
      "127.0.0.0/24"
      "::1/128"
    ];
  };
  services.openssh.enable = true;
  services.expressvpn.enable = true;
}
