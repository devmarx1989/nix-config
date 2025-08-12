{
  config,
  services,
  ...
}: let
  ports = config.my.ports; # optional convenience alias
  grafanaPort = ports.grafana;
  prome = toString ports.prometheus;
  loki = toString ports.lokiHttp;

  # --- Declarative dashboards fetched from grafana.com ---
  # First build will fail with a "got sha256:" message; copy that hash back in place of lib.fakeSha256.

  # Node Exporter Full (ID 1860)
  nodeExporterFull = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/1860/revisions/<REV>/download";
    sha256 = lib.fakeSha256;
  };

  # Prometheus 2.0 Overview (ID 3662) – you can swap to a newer fork if you prefer
  promOverview = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/3662/revisions/<REV>/download";
    sha256 = lib.fakeSha256;
  };

  # CoreDNS (pick a revision that matches your CoreDNS; 14981 is a common modern one)
  coredns = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/14981/revisions/<REV>/download";
    sha256 = lib.fakeSha256;
  };

  # Loki overview / metrics (ID 13186)
  lokiSelf = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/13186/revisions/<REV>/download";
    sha256 = lib.fakeSha256;
  };

  # Build a read-only directory Grafana can scan
  dashboardsPkg = pkgs.linkFarm "grafana-dashboards" [
    { name = "Infra/Node Exporter Full.json"; path = nodeExporterFull; }
    { name = "Infra/Prometheus 2.0 Overview.json"; path = promOverview; }
    { name = "Infra/CoreDNS.json"; path = coredns; }
    { name = "Infra/Loki.json"; path = lokiSelf; }
  ];
in {
  services.grafana = {
    enable = true;
    dataDir = "/store/grafana";
    settings.server = {
      http_addr = "127.0.0.1"; # only expose to localhost; Caddy handles public
      http_port = grafanaPort;
      #domain = "grafana.example.com";
      #root_url = "https://grafana.example.com/";  # important for links/cookies
    };

    settings.security = {
      admin_user = "admin";
      admin_password = "admin";
    };

    settings.users.allow_sign_up = false;

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:${prome}";
          isDefault = true;
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://localhost:${loki}";
        }
      ];
    };
  };
}
