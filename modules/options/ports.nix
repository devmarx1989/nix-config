# modules/options/ports.nix
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;

  # <<< KEEP YOUR SERVICE NAMES HERE >>>  (array of strings, as requested)
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
    # add any other names you already use
  ];

  # Declare one option per service name from the *static* list.
  # NOTE: index via lib.elemIndex (returns an int), no imap0 shenanigans.
  mkPortOptions = names:
    lib.foldl' (
      acc: name:
        acc
        // {
          ${name} = mkOption {
            type = types.port;
            default = let
              idx = lib.elemIndex name names; # 0-based integer
            in
              config.my.ports.base + idx;
            description = "Port for ${name}.";
          };
        }
    ) {}
    names;
in {
  options.my.ports =
    {
      # Single knob to shift the whole block
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
    # Add per-service port options from the static list
    // mkPortOptions srvPorts;

  # Anything that *reads* config belongs here (safe phase).
  config = {
    # Convenience: name->port map and ordered list of ports following `services`
    my.ports = {
      map = lib.listToAttrs (map
        (name: {
          inherit name;
          value = builtins.getAttr name config.my.ports;
        })
        config.my.ports.services);

      list =
        map (name: builtins.getAttr name config.my.ports)
        config.my.ports.services;
    };

    # Guardrail: no dup ports among the listed services
    assertions = [
      {
        assertion = let
          ports =
            map (name: builtins.getAttr name config.my.ports)
            config.my.ports.services;
        in
          lib.length (lib.unique ports) == lib.length ports;
        message = "my.ports: duplicate port assignments detected in services list.";
      }
    ];
  };
}
