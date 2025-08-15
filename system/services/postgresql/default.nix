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
  services.postgresql = {
    enable = true;
    port = ps;
    package = pkgs.postgresql_18_jit;
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
        name = root;
        ensureDBOwnership = true;
        ensureClauses = {
          superuser = true;
          createrole = true;
          createdb = true;
        };
      }
      {
        name = promUser;
        ensureDBOwnership = true;
        ensureClauses = {
          superuser = true;
          createrole = true;
          createdb = true;
        };
      }
    ];

    ensureDatabases = [
      root
      promUser
      "data"
    ];

    enableTCPIP = true;
    enableJIT = true;
    dataDir = "/store/postgresql";
    checkConfig = true;

    initialScript = pkgs.writeText "init-sql-script" ''
      alter user ${root} with password ${pass};
      -- As a superuser on the DB:
      CREATE ROLE ${promUser} LOGIN PASSWORD ${pass};

      -- Easiest (PG 10+): grant the built-in monitor role
      GRANT pg_monitor TO ${promUser};

      -- Optional but very useful:
      -- If you use pg_stat_statements, make sure it's enabled in postgresql.conf:
      -- shared_preload_libraries = 'pg_stat_statements'
      -- Then:
      GRANT SELECT ON pg_stat_statements TO ${promUser};
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

    extensions = ps:
      with ps; [
        h3-pg
        jsonb_deep_sum
        lantern
        periods
        pg-semver
        pg_bigm
        pg_byteamagic
        pg_hll
        pg_ivm
        pg_net
        pg_partman
        pg_rational
        pg_relusage
        pg_repack
        pg_roaringbitmap
        pg_similarity
        pgsodium
        pg_uuidv7
        pgddl
        pgjwt
        pgmq
        pgroonga
        pgrouting
        pgsql-http
        pgtap
        pgvectorscale
        plpgsql_check
        plpython3
        plv8
        postgis
        rum
        smlar
        system_stats
        temporal_tables
        timescaledb
        timescaledb_toolkit
        tsja
        wal2json
      ];
  };
}
