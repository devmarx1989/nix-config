{services, ...}: let
  ports = config.my.ports;
  ps = ports.postgres;
  promUser = "postgres-exporter";
  pgPort = ports.promPostgres;
  root = "admin";
  pass = "admin";
in {
  services.postgresql.initialScript = pkgs.writeText "init-sql-script" ''
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
}
