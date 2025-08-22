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
  user = u: {
    name = u;
    ensureDBOwnership = true;
    ensureClauses = {
      superuser = true;
      createrole = true;
      createdb = true;
    };
  };
  users = [
    root
    promUser
    "postgres"
    "bitmagnet"
    "prowlarr"
    "readarr"
  ];
in {
  services.postgresql = {
    ensureUsers = map user users;
    ensureDatabases =
      [
        "data"
      ]
      ++ users;
  };
}
