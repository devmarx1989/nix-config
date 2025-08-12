# modules/options/ports.nix
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (builtins) length elemAt listToAttrs genList getAttr;

  # <<< KEEP YOUR SERVICE NAMES HERE, AS STRINGS >>>
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
    # ...add the rest exactly as you use them
  ];

  # Declare one port option per service name (NO defaults here!)
  mkPortOptions = names:
    lib.foldl' (
      acc: name:
        acc
        // {
          ${name} = mkOption {
            type = types.port;
            description = "Port for ${name}.";
          };
        }
    ) {}
    names;
in {
  options.my.ports =
    {
      base = mkOption {
        type = types.port;
        default = 10001;
        description = "Starting port number for sequential assignments.";
      };

      # stays an array of strings exactly as you want
      services = mkOption {
        type = types.listOf types.str;
        default = srvPorts;
        description = "Ordered service names used for port assignment and helpers.";
      };
    }
    // mkPortOptions srvPorts;

  # Do ALL arithmetic and derived values in the config phase
  config = {
    # Assign defaults for each service: base + index (0-based)
    my.ports =
      # { <service> = mkDefault (base + i); ... }
      (listToAttrs (genList
        (i: {
          name = elemAt srvPorts i;
          value = lib.mkDefault (config.my.ports.base + i);
        })
        (length srvPorts)))
      # plus convenience helpers
      // {
        # name -> realized port
        map = listToAttrs (map
          (name: {
            inherit name;
            value = getAttr name config.my.ports;
          })
          config.my.ports.services);

        # [port1 port2 ...] in the order of `services`
        list =
          map (name: getAttr name config.my.ports)
          config.my.ports.services;
      };

    # Guardrail: no duplicate ports among the listed services
    assertions = [
      {
        assertion = let
          ports =
            map (name: getAttr name config.my.ports)
            config.my.ports.services;
        in
          lib.length (lib.unique ports) == lib.length ports;
        message = "my.ports: duplicate port assignments detected in services list.";
      }
    ];
  };
}
