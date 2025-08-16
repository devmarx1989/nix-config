{
  config,
  pkgs,
  lib,
  ...
}: let
  ports = config.my.ports;
  squidHttp = toString ports.squidProxy;
  squidProm = toString ports.squidProm;
in {
  systemd.services.prometheus-squid-exporter = {
    description = "Prometheus Squid Exporter";
    wantedBy = ["multi-user.target"];
    after = ["network.target" "squid.service"];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-squid-exporter}/bin/prometheus-squid-exporter \
          -squid-hostname 127.0.0.1 \
          -squid-port ${squidHttp} \
          -listen ":${squidProm}" \
      '';
      DynamicUser = true;
      Restart = "always";
    };
  };
}
