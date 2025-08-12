# modules/options/ports.nix
{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.lists) findFirstIndex;

  # KEEP YOUR SERVICE NAMES *AS STRINGS* HERE (static; do not read `config` here)
  srvPorts = [
    "avahi"
    "alertmanager"
    "cadvisor"
    "calibreServer"
    "calibreWeb"
    "coreDns"
    "coreDnsMetrics"
    "grafana"
    "lokiHttp"
    "lokiGrpc"
    "nodeExporter"
    "ollama"
    "prometheus"
    "promtail"
    "qbittorrentWeb"
    "squidProxy"
    "squidTlsBump"
    # …add the rest exactly as you use them
  ];

  # Declare per-service *options* from the static list.
  # NOTE: compute index with lib.lists.findFirstIndex
  mkPortOptions = names:
    lib.foldl' (acc: name:
      acc // {
        ${name} = mkOption {
          type = types.port;
          default =
            let
              idx = findFirstIndex (n: n == name) names;
            in
              if idx == null then
                throw "my.ports: service '${name}' not found in srvPorts"
              else
                config.my.ports.base + idx;
          description = "Port for ${name}.";
        };
      }
    ) {} names;

in
{
  options.my.ports =
    {
      # One knob to shift everything
      base = mkOption {
        type = types.port;
        default = 10001;
        description = "Starting port number for sequential assignments.";
      };

      # *** This stays an array of strings ***
      services = mkOption {
        type = types.listOf types.str;
        default = srvPorts;
        description = "Ordered service names used for port assignment and helpers.";
      };
    }
    # Add one option per service from the STATIC list (no `config` usage here)
    // mkPortOptions srvPorts;

  # Anything that *reads* from `config` goes here (safe phase)
  config = {
    # Convenience helpers derived from your services list (kept as strings)
    my.ports = {
      # { name -> port }
      map = lib.listToAttrs (map
        (name: { inherit name; value = builtins.getAttr name config.my.ports; })
        config.my.ports.services);

      # [port1 port2 …] in services order (useful for firewall openings)
      list = map (name: builtins.getAttr name config.my.ports)
                 config.my.ports.services;
    };

    # Guardrail: detect dup assignments among listed services
    assertions = [{
      assertion =
        let ports = map (name: builtins.getAttr name config.my.ports)
                        config.my.ports.services;
        in lib.length (lib.unique ports) == lib.length ports;
      message = "my.ports: duplicate port assignments detected in services list.";
    }];
  };
}

