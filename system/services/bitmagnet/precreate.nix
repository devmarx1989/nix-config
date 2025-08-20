{
  config,
  pkgs,
  lib,
  ...
}: let
  ports = config.my.ports;
  pgPort = toString ports.postgres; # <-- your running Postgres port
in {
  ##############################################################################
  # One-shot: make sure the "bitmagnet" DB exists on your external Postgres
  ##############################################################################
  systemd.services."bitmagnet-precreate-db" = {
    description = "Ensure 'bitmagnet' database exists (external PostgreSQL)";
    before = ["bitmagnet.service"];
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      Environment = ["PGPASSWORD=admin"];
      ExecStart = ''
        ${pkgs.bash}/bin/bash -lc '
          # returns one row if DB exists; nothing if missing
          if ${pkgs.postgresql}/bin/psql \
                -h 127.0.0.1 -p ${pgPort} -U admin -d postgres \
                -Atc "SELECT 1 FROM pg_database WHERE datname = $$bitmagnet$$;" \
             | ${pkgs.gnugrep}/bin/grep -q 1; then
            exit 0
          else
            ${pkgs.postgresql}/bin/createdb -h 127.0.0.1 -p ${pgPort} -U admin bitmagnet
          fi
        '
      '';
    };
  };
}
