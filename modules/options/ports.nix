# modules/options/ports.nix
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types imap0 listToAttrs attrByPath;
  cfg = config.my.ports;
  srvPorts = [
    "avahi"
    "alertmanager"
    "cadvisor"
    "calibreServer"
    "calibreWeb"
    "coreDns"
    "coreDnsMetrics"
    "grafana"
    "ipfs0"
    "ipfs1"
    "ipfs2"
    "ipfs3"
    "ipfs4"
    "jellyfinHttp"
    "jellyfinHttps"
    "lokiGrpc"
    "lokiHttp"
    "nodeExporter"
    "ollama"
    "prometheus"
    "promtailHttp"
    "promtailGrpc"
    "qbittorrentWeb"
    "squidProxy"
    "squidTlsBump"
  ];

  # Build options for each service name, defaulting to base + index (unless overridden)
  mkPortOptions = names:
    listToAttrs (imap0
      (i: name: {
        name = name;
        value = mkOption {
          type = types.port;
          # If user set my.ports.overrides.<name>, use it; else base+index
          default = attrByPath [name] (cfg.base + i) cfg.overrides;
        };
      })
      names);
in {
  options.my.ports =
    {
      # Starting port number
      base = mkOption {
        type = types.port;
        default = 10001;
      };

      # List your services here (can be extended per-host with mkAfter)
      services = mkOption {
        type = with types; listOf str;
        default = srvPorts;
        description = "Names of services that will get sequential ports from base.";
      };

      # Optional hard overrides: { prometheus = 9090; grafana = 4000; }
      overrides = mkOption {
        type = types.attrsOf types.port;
        default = {};
      };
    }
    // mkPortOptions cfg.services;

  # Export convenient computed values (these are *config* values, not options)
  config.my.ports = {
    # map: { grafana = 10001; prometheus = 10002; ... }
    map = listToAttrs (map
      (name: {
        inherit name;
        value = config.my.ports.${name};
      })
      cfg.services);

    # list: [10001 10002 ...], useful for firewall rules
    list = map (name: config.my.ports.${name}) cfg.services;
  };
}
