{
  config,
  lib,
  services,
  ...
}: let
  ps = config.my.ports.postgres;
in {
  services.postgresql = {
    enable = true;
    port = ps;
    settings = {
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

    ensureUsers = [
      {
        name = "root";
        ensureDBOwnership = true;
        ensureClauses = {
          superuser = true;
          createrole = true;
          createdb = true;
        };
      }
    ];

    ensureDatabases = [
      "data"
    ];

    enableTCPIP = true;
    enableJIT = true;
    dataDir = "/store/postgresql";
    checkConfig = true;

    initialScript = pkgs.writeText "init-sql-script" ''
      alter user root with password 'root';
    '';

    authentication = ''
      # Allow any user on the local system to connect to any database with
      # any database user name using Unix-domain sockets (the default for local
      # connections).
      #
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust

      # The same using local loopback TCP/IP connections.
      #
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      host    all             all             127.0.0.1/32            trust

      # The same as the previous line, but using a separate netmask column
      #
      # TYPE  DATABASE        USER            IP-ADDRESS      IP-MASK             METHOD
      host    all             all             127.0.0.1       255.255.255.255     trust

      # The same over IPv6.
      #
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      host    all             all             ::1/128                 trust

      # The same using a host name (would typically cover both IPv4 and IPv6).
      #
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      host    all             all             localhost               trust
    '';

    extensions = "pg_stat_statements";
  };
}
