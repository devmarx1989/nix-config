{
  config,
  pkgs,
  lib,
  ...
}: let
  ports = config.my.ports;
  pgPort = toString ports.postgres; # your running Postgres port

  # Script that checks/creates the DB using PG* env vars and psql/createdb.
  ensureBitmagnetDb = pkgs.writeShellScript "ensure-bitmagnet-db" ''
    set -Eeuo pipefail

    db="bitmagnet"

    # Returns "1" if exists, empty otherwise
    if psql -h 127.0.0.1 -p ${pgPort} -U admin -d postgres -tA \
            -c "SELECT 1 FROM pg_database WHERE datname='${db}'" | grep -q 1
    then
      echo "Database ${db} already exists."
      exit 0
    fi

    createdb -h 127.0.0.1 -p ${pgPort} -U admin "${db}"
    echo "Created database ${db}."
  '';
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

    # Put client tools on PATH for the script (psql/createdb/grep)
    path = [pkgs.postgresql_17 pkgs.gnugrep];

    serviceConfig = {
      Type = "oneshot";
      # keep your current creds; consider switching to .pgpass later
      Environment = ["PGPASSWORD=admin"];
      ExecStart = ensureBitmagnetDb;

      # Hardening that’s safe for local TCP connections
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
    };
  };
}
