# modules/options/ports.nix  (fixed, keeps services as an array of strings)
{ lib, config, ... }:
let
  inherit (lib) mkOption types imap0 listToAttrs attrByPath;

  # KEEP YOUR EXACT LIST HERE. Do NOT reference config here.
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

  # Generate per-service *option declarations* from the static list.
  # IMPORTANT: This runs in the options phase -> must NOT depend on config.
  mkPortOptions = names:
    lib.foldl' (acc: name:
      acc // {
        ${name} = mkOption {
          type = types.port;
          default = config.my.ports.base + (imap0 (_i: n: n) names name);
          description = "Port for ${name}.";
        };
      }
    ) {} names;

in
{
  options.my.ports =
    {
      # Single knob to shift everything
      base = mkOption {
        type = types.port;
        default = 10001;
        description = "Starting port number for sequential service assignments.";
      };

      # You asked to KEEP this as an array of strings:
      services = mkOption {
        type = types.listOf types.str;
        default = srvPorts;         # stays your static list by default
        description = "Ordered list of service names used for port assignment and helpers.";
      };
    }
    # ⬇️ Add one port option per service name — from the *static* srvPorts list
    // mkPortOptions srvPorts;

  # Anything that reads config (map/list/assertions) must be in `config = { ... }`
  config = {
    # Convenience exports that depend on final config
    my.ports = {
      # { name -> port }
      map = listToAttrs (map
        (name: {
          inherit name;
          value = attrByPath [ "my" "ports" name ] null config;
        })
        config.my.ports.services);

      # [port1 port2 ...] useful for firewall rules
      list = map (name: attrByPath [ "my" "ports" name ] null config)
                 config.my.ports.services;
    };

    # Guardrail: detect duplicates
    assertions = [{
      assertion =
        let ports = map (name: attrByPath [ "my" "ports" name ] null config)
                        config.my.ports.services;
        in lib.length (lib.unique ports) == lib.length ports;
      message = "my.ports: duplicate port assignments detected in services list.";
    }];
  };
}

