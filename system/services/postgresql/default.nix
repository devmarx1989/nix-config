{
  config,
  lib,
  pkgs,
  services,
  ...
}: let
  ports = config.my.ports;
  ps = ports.postgres;
  promUser = "postgres-exporter";
  pgPort = ports.promPostgres;
  root = "admin";
  pass = "admin";
in {
  imports = [
    ./authentication.nix
    ./ensureUsers.nix
    ./extensions.nix
    ./initialScript.nix
  ];
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17_jit;
    settings = {
      port = ps;
      log_line_prefix = "%m [%p] ";
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
    };

    initdbArgs = [
      "--data-checksums"
      "--allow-group-access"
    ];

    ensureDatabases = [
      root
      promUser
      "data"
      "postgresql"
    ];

    enableTCPIP = true;
    enableJIT = true;
    dataDir = "/store/postgresql";
    checkConfig = true;
  };
  systemd.services.postgresql.unitConfig.RequiresMountsFor = ["/store/postgresql"];

  # Only create cache parents; no ssl/ssl_db anymore
  systemd.tmpfiles.rules = [
    "d /store/postgresql   0777 postgresql postgresql - -"
  ];
}
