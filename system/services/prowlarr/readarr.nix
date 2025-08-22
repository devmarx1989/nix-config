{
  services,
  config,
  pkgs,
  ...
}: let
  ports = config.my.ports;
  postgresPort = ports.postgres;
  readarrPort = 11002;
  readarrPortss = toString readarrPort;
in {
  services.readarr = {
    enable = true;
    package = pkgs.readarr;
    openFirewall = false;
    user = "readarr";
    group = "readarr";

    # updated location
    dataDir = "/store/readarr";

    settings = {
      server = {
        bindAddress = "127.0.0.1";
        port = readarrPort;
      };
      log.analyticsEnabled = false;
      update.mechanism = "external";
      update.automatically = false;
      postgres = {
        host = "127.0.0.1";
        port = postgresPort;
        user = "readarr";
        mainDb = "readarr";
        logDb = "readarr-log";
      };
    };

    environmentFiles = ["/run/secrets/readarr.env"];
  };

  # Ensure dataDir exists with correct perms
  systemd.tmpfiles.rules = [
    "d /store/readarr 0750 readarr readarr -"
  ];

  ## Prometheus exporter: exportarr (Readarr)
  ###########################################
  services.prometheus.exporters.exportarr-readarr = {
    enable = true; # confirmed option
    package = pkgs.exportarr; # confirmed option (default)
    listenAddress = "127.0.0.1"; # confirmed option
    # choose a free port for the Readarr exporter; avoid promPort (used by Prowlarr)
    port = 11003; # confirmed option

    openFirewall = false; # confirmed option

    # Point at your Readarr HTTP URL and supply API key via file
    url = "http://127.0.0.1:${readarrPortss}"; # confirmed option
    apiKeyFile = "/run/secrets/readarr-api-key"; # confirmed option

    # Run-as user/group (kept separate from app user)
    user = "exportarr-readarr-exporter"; # confirmed option
    group = "exportarr-readarr-exporter"; # confirmed option

    # Extra exporter flags (optional)
    extraFlags = []; # confirmed option
    environment = {}; # confirmed option
    # firewallRules = [ ];   # confirmed option
    # firewallFilter = "";   # confirmed option
  };
}
