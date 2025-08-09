{services, ...}: {
  services.grafana = {
    enable = true;
    dataDir = "/store/grafana";
    settings.server = {
      http_addr = "127.0.0.1"; # only expose to localhost; Caddy handles public
      http_port = 1040;
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
          url = "http://localhost:1020";
          isDefault = true;
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://localhost:1030";
        }
      ];
    };
  };
}
