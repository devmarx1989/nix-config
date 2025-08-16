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
in {
  systemd.services.prometheus-squid-exporter = {
    description = "Prometheus Squid Exporter";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "squid.service"];
    wants = ["network-online.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.squid-exporter}/bin/squid-exporter \
          -squid-hostname 127.0.0.1 \
          -squid-port ${squidHttp} \
          -listen ":${squidProm}"
      '';
      # Optional: expose process_* FDs metric (see README)
      # AmbientCapabilities = "CAP_DAC_READ_SEARCH";
      # CapabilityBoundingSet = "CAP_DAC_READ_SEARCH";
      DynamicUser = true;
      Restart = "always";
    };
  };
}
