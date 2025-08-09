{ config, pkgs, ... }:

{
  #####################
  # Promtail (agent)
  #####################
  services.promtail = {
    enable = true;
    configuration = {
      server = { http_listen_port = 1032; grpc_listen_port = 0; };
      positions = { filename = "/store/promtail/positions.yaml"; };

      clients = [{
        url = "http://127.0.0.1:1030/loki/api/v1/push";
      }];

      scrape_configs = [
        # Systemd journal
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            path = "/var/log/journal";
            labels = { job = "systemd-journal"; host = "${config.networking.hostName}"; };
          };
          relabel_configs = [
            { source_labels = ["__journal__systemd_unit"]; target_label = "unit"; }
            { source_labels = ["__journal__hostname"];      target_label = "hostname"; }
            { source_labels = ["__journal__transport"];     target_label = "transport"; }
          ];
        }

        # /var/log/*.log
        {
          job_name = "varlogs";
          static_configs = [{
            targets = ["localhost"];
            labels = {
              job = "varlogs";
              __path__ = "/var/log/*.log";
              host = "${config.networking.hostName}";
            };
          }];
        }
      ];
    };
  };

  users.users.promtail.extraGroups = [ "systemd-journal" ];
  systemd.tmpfiles.rules += [
    "d /store/promtail 0750 promtail promtail -"
  ];
}

