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
  ports = config.my.ports;
  am = ports.alertmanager;
  ams = toString ports.alertmanager;
  corednsProm = toString ports.corednsProm;
  loki = toString ports.lokiHttp;
  node = ports.nodeExporter;
  nodes = toString node;
  promWebPort = ports.prometheus;
  promWebPorts = toString ports.prometheus;
  promtail = toString ports.promtailHttp;
  ipfs = toString ports.ipfs4;
in {
  #### Prometheus server
  services.prometheus = {
    enable = true;
    listenAddress = "0.0.0.0"; # expose on LAN/WAN
    extraFlags = [
      "--web.enable-lifecycle"
    ];
    port = promWebPort;
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
        static_configs = [{targets = ["localhost:${promWebPorts}"];}];
      }
      # Scrape node exporter
      {
        job_name = "node";
        static_configs = [{targets = ["localhost:${nodes}"];}];
      }
      {
        job_name = "coredns";
        metrics_path = "/metrics";
        scheme = "http";
        static_configs = [
          {
            targets = ["127.0.0.1:${corednsProm}"];
            labels = {
              job = "coredns";
              # optional: helps k8s-flavored dashboards light up
              namespace = "kube-system";
              pod = "coredns-standalone";
            };
          }
        ];
      }
      {
        job_name = "loki";
        static_configs = [{targets = ["127.0.0.1:${loki}"];}];
      }
      {
        job_name = "promtail";
        static_configs = [{targets = ["127.0.0.1:${promtail}"];}];
      }
      {
        job_name = "ipfs";
        metrics_path = "/debug/metrics/prometheus";
        static_configs = [{
          targets = [ "127.0.0.1:${ipfs}" ];
        }];
      }
    ];

    # Wire Prometheus to Alertmanager
    alertmanagers = [
      {static_configs = [{targets = ["localhost:${ams}"];}];}
    ];

    # Example: add your own alert rules (optional)
    ruleFiles = [baseRules];
  };

  #### Node exporter (host metrics)
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = node;
  };

  #### Minimal Alertmanager
  services.prometheus.alertmanager = {
    enable = true;
    listenAddress = "0.0.0.0";
    port = am;
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
