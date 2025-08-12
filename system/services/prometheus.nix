{
  config,
  pkgs,
  ...
}: let
  baseRules = pkgs.writeText "prom-base-rules.yml" ''
    groups:
    - name: sanity
      rules:
      - record: up:sum
        expr: sum(up)
  '';
in {
  #### Prometheus server
  services.prometheus = {
    enable = true;
    listenAddress = "0.0.0.0"; # expose on LAN/WAN
    extraFlags = [
      "--web.enable-lifecycle"
    ];
    port = 4000;
    # Global scrape/defaults
    globalConfig = {
      scrape_interval = "15s";
      evaluation_interval = "15s";
    };
    # Where to scrape
    scrapeConfigs = [
      # Scrape Prometheus itself
      {
        job_name = "prometheus";
        static_configs = [{targets = ["localhost:4000"];}];
      }
      # Scrape node exporter
      {
        job_name = "node";
        static_configs = [{targets = ["localhost:4001"];}];
      }
      {
        job_name = "coredns";
        metrics_path = "/metrics";
        scheme = "http";
        static_configs = [
          {targets = ["127.0.0.1:4002"];}
        ];
      }
      {
        job_name = "loki";
        static_configs = [{targets = ["127.0.0.1:4003"];}];
      }
      {
        job_name = "promtail";
        static_configs = [{targets = ["127.0.0.1:4004"];}];
      }
    ];

    # Wire Prometheus to Alertmanager
    alertmanagers = [
      {static_configs = [{targets = ["localhost:4005"];}];}
    ];

    # Example: add your own alert rules (optional)
    ruleFiles = [baseRules];
  };

  #### Node exporter (host metrics)
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 4001;
    enabledCollectors = [
      "boottime"
      "cpu"
      "cpufreq"
      "diskstats"
      "filesystem"
      "loadavg"
      "logind"
      "meminfo"
      "netclass"
      "netdev"
      "netstat"
      "pressure"
      "systemd"
      "textfile"
    ];
  };

  #### Minimal Alertmanager
  services.prometheus.alertmanager = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 4005;
    configuration = {
      route = {receiver = "null";};
      receivers = [{name = "null";}];
    };
  };

  # Example for Grafana to point at Prometheus on port 4000:
  # services.grafana.provision.datasources = [{
  #   name = "Prometheus";
  #   type = "prometheus";
  #   url  = "http://localhost:4000";
  #   isDefault = true;
  # }];
}

