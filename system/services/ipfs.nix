{services, ...}: {
  services.kubo = {
    enable = false;
    dataDir = "/drive/Media/ipfs";

    pinnedFiles = [
      "bafybeicxcbb23czpad3jvbqpeg6z3ozbrohljxq37bfmzsjzbr3c32q2t4"
    ];

    # Kubo settings
    settings = {
      Addresses = {
        # Libp2p listeners
        Swarm = [
          # TCP swarm
          "/ip4/0.0.0.0/tcp/2002"
          "/ip6/::/tcp/2002"

          # QUIC v1 (UDP) swarm
          "/ip4/0.0.0.0/udp/2003/quic-v1"
          "/ip6/::/udp/2003/quic-v1"

          # WebSocket transport
          "/ip4/0.0.0.0/tcp/2004/ws"
          "/ip6/::/tcp/2004/ws"
        ];

        # API + Gateway (local-only)
        API = ["/ip4/127.0.0.1/tcp/2005"];
        Gateway = "/ip4/127.0.0.1/tcp/2006";

        # With unstable/unknown public IP, do not hardcode Announce.
        Announce = [];
        # Keep standard NoAnnounce so we don't advertise private addrs.
        NoAnnounce = [
          "/ip4/127.0.0.0/ipcidr/8"
          "/ip4/10.0.0.0/ipcidr/8"
          "/ip4/100.64.0.0/ipcidr/10"
          "/ip4/169.254.0.0/ipcidr/16"
          "/ip4/172.16.0.0/ipcidr/12"
          "/ip4/192.0.0.0/ipcidr/24"
          "/ip4/192.0.2.0/ipcidr/24"
          "/ip4/192.168.0.0/ipcidr/16"
          "/ip4/198.18.0.0/ipcidr/15"
          "/ip4/198.51.100.0/ipcidr/24"
          "/ip4/203.0.113.0/ipcidr/24"
          "/ip4/240.0.0.0/ipcidr/4"
          "/ip6/100::/ipcidr/64"
          "/ip6/2001:2::/ipcidr/48"
          "/ip6/2001:db8::/ipcidr/32"
          "/ip6/fc00::/ipcidr/7"
          "/ip6/fe80::/ipcidr/10"
        ];
      };

      # Swarm/NAT/relay behavior tuned for changing IPs / CGNAT.
      Swarm = {
        DisableNatPortMap = false; # try UPnP/NAT-PMP if available
        EnableHolePunching = true; # DCUtR
        RelayClient = {Enabled = true;}; # AutoRelay client
      };

      # Optional: bump conn manager a bit (safe defaults)
      ConnectionManager = {
        HighWater = 2000;
        LowWater = 1000;
        GracePeriod = "20s";
      };

      # CORS for API and Gateway (local dev convenience)
      API = {
        HTTPHeaders = {
          "Access-Control-Allow-Origin" = ["http://127.0.0.1:2005" "http://127.0.0.1:2006" "*"];
          "Access-Control-Allow-Methods" = ["GET" "POST" "PUT" "OPTIONS"];
        };
      };
      Gateway = {
        HTTPHeaders = {
          "Access-Control-Allow-Origin" = ["http://127.0.0.1:2005" "http://127.0.0.1:2006" "*"];
          "Access-Control-Allow-Methods" = ["GET" "POST" "OPTIONS"];
        };
        RootRedirect = "/webui"; # 2006/ -> WebUI
      };
    };
  };
}
