{services, ...}: {
  services.kubo = {
    enable = true;
    dataDir = "/drive/Media/ipfs";

    # Kubo settings
    settings = {
      Addresses = {
        # Libp2p listeners
        Swarm = [
          # TCP swarm
          "/ip4/0.0.0.0/tcp/1002"
          "/ip6/::/tcp/1002"

          # QUIC v1 (UDP) swarm
          "/ip4/0.0.0.0/udp/1003/quic-v1"
          "/ip6/::/udp/1003/quic-v1"

          # WebSocket transport (optional but handy for some peers)
          "/ip4/0.0.0.0/tcp/1004/ws"
          "/ip6/::/tcp/1004/ws"
        ];

        # Expose API on TCP for WebUI
        API = ["/ip4/127.0.0.1/tcp/1005"];

        # HTTP Gateway on TCP
        Gateway = "/ip4/127.0.0.1/tcp/1006";

        # If you need to force what you announce (NAT issues), you can add:
        # Announce = [ "/ip4/<your-public-ip>/tcp/1002" "/ip4/<your-public-ip>/udp/1003/quic-v1" ];
        # NoAnnounce = [ ];
      };

      # (Optional) keep NAT traversal on; helps inbound reachability
      Swarm = {
        DisableNatPortMap = false;
        # EnableRelayHop = true;  # only if you *intend* to act as a hop relay
      };

      # (Optional) CORS headers so browser apps can talk to your API/Gateway locally
      API = {
        HTTPHeaders = {
          "Access-Control-Allow-Origin" = ["http://127.0.0.1:1005" "http://127.0.0.1:1006" "*"];
          "Access-Control-Allow-Methods" = ["GET" "POST" "PUT" "OPTIONS"];
        };
      };
      Gateway = {
        HTTPHeaders = {
          "Access-Control-Allow-Origin" = ["http://127.0.0.1:1005" "http://127.0.0.1:1006" "*"];
          "Access-Control-Allow-Methods" = ["GET" "POST" "OPTIONS"];
        };
        RootRedirect = "/webui"; # uncomment if you want 1006/ to jump to the WebUI
      };
    };
  };
}
