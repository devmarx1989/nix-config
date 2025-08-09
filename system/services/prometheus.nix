{
  config,
  pkgs,
  ...
}: {
  #### Prometheus server
  services.prometheus = {
    enable = true;
    listenAddress = "0.0.0.0"; # expose on LAN/WAN
    extraFlags = [
      "--storage.tsdb.path=/store/prometheus"
    ];
    port = 1020;
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
        static_configs = [{targets = ["localhost:1020"];}];
      }
      # Scrape node exporter
      {
        job_name = "node";
        static_configs = [{targets = ["localhost:1021"];}];
      }
      {
        job_name = "coredns";
        metrics_path = "/metrics";
        scheme = "http";
        static_configs = [
          {targets = ["127.0.0.1:1001"];}
        ];
      }
      {
        job_name = "loki";
        static_configs = [{targets = ["127.0.0.1:1030"];}];
      }
      {
        job_name = "promtail";
        static_configs = [{targets = ["127.0.0.1:1032"];}];
      }
    ];

    # Wire Prometheus to Alertmanager
    alertmanagers = [
      {static_configs = [{targets = ["localhost:1022"];}];}
    ];

    # Example: add your own alert rules (optional)
    ruleFiles = ["/store/prometheus/rules/*.yml"];
  };

  #### Node exporter (host metrics)
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 1021;
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
    # openFirewall = true; # only if needed
  };

  #### Minimal Alertmanager
  services.prometheus.alertmanager = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = 1022;
    configuration = {
      route = {receiver = "null";};
      receivers = [{name = "null";}];
    };
  };

  # If you want Grafana to point at Prometheus on 1020, add:
  # services.grafana.provision.datasources = [{
  #   name = "Prometheus";
  #   type = "prometheus";
  #   url  = "http://localhost:1020";
  #   isDefault = true;
  # }];
}
