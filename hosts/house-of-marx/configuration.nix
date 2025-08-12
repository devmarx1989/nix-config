# hosts/house-of-marx/configuration.nix (snippet)
{ config, pkgs, ... }:
{
  # Optional: override some ports per host
  # my.ports = { grafana = 12001; };  # shifts only Grafana

  services.grafana = {
    enable = true;
    settings.server.http_port = config.my.ports.grafana;
  };

  services.prometheus = {
    enable = true;
    webExternalUrl = "http://localhost:${toString config.my.ports.prometheus}";
    # If you run it manually:
    # extraFlags = [ "--web.listen-address=0.0.0.0:${toString config.my.ports.prometheus}" ];
  };

  services.nixos-exporter.enable = true; # example
  # If your node exporter needs the port:
  # services.prometheus.exporters.node.port = config.my.ports.nodeExporter;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    # Jellyfin option name differs by module version; commonly:
    # services.jellyfin.settings."server.httplistenport" = config.my.ports.jellyfin;
  };

  services.coredns = {
    enable = true;
    # CoreDNS still listens on 53 for DNS; this is just metrics:
    metricsPort = config.my.ports.coreDnsMetrics;
  };

  # qBittorrent (service or container) would read:
  # services.qbittorrent.webui.port = config.my.ports.qbittorrentWeb;

  # If you run calibre-web:
  # services.calibre-web.listen.port = config.my.ports.calibreWeb;
}

