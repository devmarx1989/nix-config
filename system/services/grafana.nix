{
  config,
  services,
  ...
}: let
  ports = config.my.ports; # optional convenience alias
  grafanaPort = ports.grafana;
  prome = toString ports.prometheus;
  loki = toString ports.lokiHttp;
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
