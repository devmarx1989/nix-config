# modules/options/ports.nix
{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.my.ports;

  # Keep every port here to assert uniqueness.
  allPorts = [
    cfg.grafana
    cfg.prometheus
    cfg.alertmanager
    cfg.nodeExporter
    cfg.cadvisor
    cfg.lokiHttp
    cfg.lokiGrpc
    cfg.promtail
    cfg.jellyfin
    cfg.calibreWeb
    cfg.calibreServer
    cfg.coreDns
    cfg.coreDnsMetrics
    cfg.squidProxy
    cfg.squidTlsBump
    cfg.ollama
    cfg.qbittorrentWeb
  ];
in
{
  options.my.ports = {
    # Shift the whole block by changing base.
    base = mkOption {
      type = types.port;
      default = 10001;
      description = "Starting port number for sequential service assignments.";
    };

    grafana       = mkOption { type = types.port; default = cfg.base + 0;  description = "Grafana HTTP."; };
    prometheus    = mkOption { type = types.port; default = cfg.base + 1;  description = "Prometheus web UI/API."; };
    alertmanager  = mkOption { type = types.port; default = cfg.base + 2;  description = "Prometheus Alertmanager HTTP."; };
    nodeExporter  = mkOption { type = types.port; default = cfg.base + 3;  description = "Node exporter HTTP."; };
    cadvisor      = mkOption { type = types.port; default = cfg.base + 4;  description = "cAdvisor HTTP."; };

    lokiHttp      = mkOption { type = types.port; default = cfg.base + 5;  description = "Loki HTTP API/UI."; };
    lokiGrpc      = mkOption { type = types.port; default = cfg.base + 6;  description = "Loki gRPC."; };
    promtail      = mkOption { type = types.port; default = cfg.base + 7;  description = "Promtail HTTP/metrics."; };

    jellyfin      = mkOption { type = types.port; default = cfg.base + 8;  description = "Jellyfin web UI."; };
    calibreWeb    = mkOption { type = types.port; default = cfg.base + 9;  description = "Calibre-Web HTTP."; };
    calibreServer = mkOption { type = types.port; default = cfg.base + 10; description = "Calibre content server HTTP."; };

    coreDns       = mkOption { type = types.port; default = cfg.base + 11; description = "CoreDNS (DNS listener when not using 53)."; };
    coreDnsMetrics= mkOption { type = types.port; default = cfg.base + 12; description = "CoreDNS Prometheus metrics."; };

    squidProxy    = mkOption { type = types.port; default = cfg.base + 13; description = "Squid HTTP proxy port."; };
    squidTlsBump  = mkOption { type = types.port; default = cfg.base + 14; description = "Squid TLS-bump listener."; };

    ollama        = mkOption { type = types.port; default = cfg.base + 15; description = "Ollama HTTP API."; };
    qbittorrentWeb= mkOption { type = types.port; default = cfg.base + 16; description = "qBittorrent Web UI."; };
  };

  # Guardrail: no accidental duplicates.
  config.assertions = [{
    assertion = lib.length (lib.unique allPorts) == lib.length allPorts;
    message = "my.ports: duplicate port assignments detected.";
  }];
}

