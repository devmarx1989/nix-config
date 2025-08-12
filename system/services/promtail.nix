{
  config,
  pkgs,
  ...
}: let
  ports = config.my.ports;
  http = ports.promtailHttp;
  grpc = ports.promtailGrpc;
  loki = toString ports.lokiHttp;
in {
  #####################
  # Promtail (agent)
  #####################
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = http;
        grpc_listen_port = grpc;
      };
      positions = {filename = "/store/promtail/positions.yaml";};

      clients = [
        {
          url = "http://127.0.0.1:${loki}/loki/api/v1/push";
        }
      ];

      scrape_configs = [
        # Systemd journal
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            path = "/var/log/journal";
            labels = {
              job = "systemd-journal";
              host = "${config.networking.hostName}";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
            {
              source_labels = ["__journal__hostname"];
              target_label = "hostname";
            }
            {
              source_labels = ["__journal__transport"];
              target_label = "transport";
            }
          ];
        }

        # /var/log/*.log
        {
          job_name = "varlogs";
          static_configs = [
            {
              targets = ["localhost"];
              labels = {
                job = "varlogs";
                __path__ = "/var/log/*.log";
                host = "${config.networking.hostName}";
              };
            }
          ];
        }
      ];
    };
  };

  users.users.promtail.extraGroups = ["systemd-journal"];
}
