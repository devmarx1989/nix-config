# modules/options/ports.nix
{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.my.ports;

  # Keep the list in one place so we can assert uniqueness.
  allPorts = [
    cfg.grafana
    cfg.prometheus
    cfg.alertmanager
    cfg.nodeExporter
    cfg.cadvisor
    cfg.loki
    cfg.promtail
    cfg.jellyfin
    cfg.calibreWeb
    cfg.calibreServer
    cfg.coreDnsMetrics
    cfg.gluetunHttp
    cfg.bitmagnet
    cfg.qbittorrentWeb
  ];
in
{
  options.my.ports = {
    # Base lets you shift the whole block if you ever need to.
    base = mkOption {
      type = types.port;
      default = 10001;
      description = "Starting port number for sequential service assignments.";
    };

    # Observability stack
    grafana = mkOption {
      type = types.port;
      default = cfg.base + 0;   # 10001
      description = "Grafana HTTP.";
    };
    prometheus = mkOption {
      type = types.port;
      default = cfg.base + 1;   # 10002
      description = "Prometheus web UI/API.";
    };
    alertmanager = mkOption {
      type = types.port;
      default = cfg.base + 2;   # 10003
      description = "Prometheus Alertmanager web UI/API.";
    };
    nodeExporter = mkOption {
      type = types.port;
      default = cfg.base + 3;   # 10004
      description = "Node Exporter HTTP (if enabled).";
    };
    cadvisor = mkOption {
      type = types.port;
      default = cfg.base + 4;   # 10005
      description = "cAdvisor HTTP UI/API.";
    };
    loki = mkOption {
      type = types.port;
      default = cfg.base + 5;   # 10006
      description = "Loki HTTP API/UI.";
    };
    promtail = mkOption {
      type = types.port;
      default = cfg.base + 6;   # 10007
      description = "Promtail HTTP/metrics (if exposed).";
    };

    # Media / apps
    jellyfin = mkOption {
      type = types.port;
      default = cfg.base + 7;   # 10008
      description = "Jellyfin web UI.";
    };
    calibreWeb = mkOption {
      type = types.port;
      default = cfg.base + 8;   # 10009
      description = "Calibre-Web web UI.";
    };
    calibreServer = mkOption {
      type = types.port;
      default = cfg.base + 9;   # 10010
      description = "calibre-server (content server).";
    };

    # Network / infra
    coreDnsMetrics = mkOption {
      type = types.port;
      default = cfg.base + 10;  # 10011
      description = "CoreDNS Prometheus/metrics endpoint (not port 53).";
    };
    gluetunHttp = mkOption {
      type = types.port;
      default = cfg.base + 11;  # 10012
      description = "Gluetun HTTP control/metrics.";
    };

    # BitTorrent / indexers
    bitmagnet = mkOption {
      type = types.port;
      default = cfg.base + 12;  # 10013
      description = "Bitmagnet web UI/API.";
    };
    qbittorrentWeb = mkOption {
      type = types.port;
      default = cfg.base + 13;  # 10014
      description = "qBittorrent Web UI.";
    };
  };

  # Guardrail: no accidental duplicates.
  config = {
    assertions = [
      {
        assertion = lib.length (lib.unique allPorts) == lib.length allPorts;
        message = "my.ports: duplicate port assignments detected. Override conflicting my.ports.* values.";
      }
    ];
  };
}

