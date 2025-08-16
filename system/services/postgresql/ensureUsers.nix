{
  service,
  config,
  ...
}: let
  ports = config.my.ports;
  ps = ports.postgres;
  promUser = "postgres-exporter";
  pgPort = ports.promPostgres;
  root = "admin";
  pass = "admin";
in {
  services.postgresql.ensureUsers = [
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
    {
      name = "postgresql";
      ensureDBOwnership = true;
      ensureClauses = {
        superuser = true;
        createrole = true;
        createdb = true;
      };
    }
  ];
}
