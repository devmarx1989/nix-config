{
  config,
  pkgs,
  lib,
  ...
}: let
  stateDir = "/store/bitmagnet";
  httpPort = config.my.bitmagnetHttp; # <-- you asked to source this here
  pgPort = config.my.port.postgres; # <-- your running Postgres port
  dhtPort = 3334; # choose any open UDP port you like
in {
  # Ensure the target exists with sane perms owned by the service user
  systemd.tmpfiles.rules = [
    "d ${stateDir} 0777 bitmagnet bitmagnet -"
  ];

  # Ensure service user/group exist (harmless if the module also creates them)
  users.groups.bitmagnet = {};
  users.users.bitmagnet = {
    isSystemUser = true;
    group = "bitmagnet";
    home = stateDir;
  };

  ##############################################################################
  # Bitmagnet itself — matches exactly the options you provided
  ##############################################################################
  services.bitmagnet = {
    enable = true; # services.bitmagnet.enable
    user = "bitmagnet"; # services.bitmagnet.user
    group = "bitmagnet"; # services.bitmagnet.group
    package = pkgs.bitmagnet; # services.bitmagnet.package

    # You are NOT using the built-in local Postgres
    useLocalPostgresDB = false; # services.bitmagnet.useLocalPostgresDB

    # services.bitmagnet.settings (passed directly to the app as YAML)
    settings = {
      # services.bitmagnet.settings.postgres
      postgres = {
        # You listed these specific keys; set them explicitly:
        user = "admin"; # services.bitmagnet.settings.postgres.user
        password = "admin"; # services.bitmagnet.settings.postgres.password
        name = "bitmagnet"; # services.bitmagnet.settings.postgres.name
        host = "127.0.0.1"; # services.bitmagnet.settings.postgres.host

        # The upstream config also accepts a DSN. Including it here ensures the non-default port is used.
        # (It lives under services.bitmagnet.settings.postgres, which you listed.)
        dsn = "postgres://admin:admin@127.0.0.1:${toString pgPort}/bitmagnet?sslmode=disable";
      };

      # services.bitmagnet.settings.http_server.port
      http_server = {
        port = httpPort; # Web UI / API / /metrics
      };

      # services.bitmagnet.settings.dht_server.port
      dht_server = {
        port = dhtPort; # DHT/BitTorrent listen port (UDP)
      };
    };
  };
}
