# system/services/systemd/squid-exporter.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  ports = config.my.ports;
  squidHttp = toString ports.squidProxy;
  squidProm = toString ports.squidProm;
  exe = "${lib.getBin pkgs.prometheus-squid-exporter}/bin/squid-exporter";
in {
  systemd.services.prometheus-squid-exporter = {
    description = "Prometheus Squid Exporter";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "squid.service"];
    wants = ["network-online.target"];

    serviceConfig = {
      ExecStart = "${exe} -squid-hostname 127.0.0.1 -squid-port ${squidHttp} -listen :${squidProm}";
      DynamicUser = true;
      Restart = "always";
    };
  };
}
