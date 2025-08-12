# modules/options/ports.nix
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (builtins) length elemAt listToAttrs genList getAttr;

  # <<< KEEP YOUR SERVICE NAMES HERE, as strings >>> (static; don't read `config` here)
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

  # Declare one *option* per service name (NO defaults here).
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

      # stays an array of strings (your requirement)
      services = mkOption {
        type = types.listOf types.str;
        default = srvPorts;
        description = "Ordered service names used for port assignment and helpers.";
      };

      # declare read-only helpers so setting them in `config` is legal
      map = mkOption {
        type = types.attrsOf types.port;
        readOnly = true;
        description = "Derived: { name -> port } for all services.";
      };

      list = mkOption {
        type = types.listOf types.port;
        readOnly = true;
        description = "Derived: [port1 port2 ...] in the order of `services`.";
      };
    }
    // mkPortOptions srvPorts;

  # Do ALL arithmetic / derivations here
  config = {
    # Assign per-service defaults: base + index
    my.ports =
      # { <service> = mkDefault (base + i); ... } generated from srvPorts order
      (listToAttrs (genList
        (i: {
          name = elemAt srvPorts i;
          value = lib.mkDefault (config.my.ports.base + i);
        })
        (length srvPorts)))
      # plus the declared read-only helpers
      // {
        map = listToAttrs (map
          (name: {
            inherit name;
            value = getAttr name config.my.ports;
          })
          config.my.ports.services);

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
        message = "my.ports: duplicate port assignments detected in `services`.";
      }
    ];
  };
}
