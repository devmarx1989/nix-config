{
  services,
  lib,
  pkgs,
  ...
}: let
  pt = 11000;
  pts = toString 11000;
  promPort = 11001;
  readarrPort = 11002;
in {
  imports = [
    ./readarr.nix
  ];
  ############
  ## Prowlarr
  ############
  services.prowlarr = {
    enable = true; # confirmed option
    package = pkgs.prowlarr; # confirmed option (default)
    dataDir = "/store/prowlarr"; # confirmed option

    # Optional: file(s) with PROWLARR__SECTION__KEY=val lines (for secrets)
    # e.g. "PROWLARR__AUTH__APIKEY=xxxxxxxxxxxxxxxxxxxx"
    environmentFiles = [
      /*
      "/run/secrets/prowlarr.env"
      */
    ]; # confirmed option

    # First-boot config (safe choices for NixOS)
    settings = {
      server.port = pt; # confirmed option
      log.analyticsEnabled = false; # confirmed option
      update = {
        mechanism = "external"; # enum: "external" | "builtIn" | "script"
        automatically = false; # avoid in-app self-updates; Nix manages version
      };
    };
  };

  ############################################
  ## Prometheus exporter: exportarr (Prowlarr)
  ############################################
  services.prometheus.exporters.exportarr-prowlarr = {
    enable = true; # confirmed option
    package = pkgs.exportarr; # confirmed option (default)
    listenAddress = "127.0.0.1"; # confirmed option
    port = promPort; # confirmed option (README uses 9707)
    openFirewall = false; # confirmed option

    # Point at your Prowlarr HTTP URL and supply API key via file
    url = "http://127.0.0.1:${pts}"; # confirmed option
    apiKeyFile = "/store/prowlarr/api-key"; # confirmed option

    # Run-as user/group (defaults are fine; set explicitly if you like)
    user = "exportarr-prowlarr-exporter"; # confirmed option (module supports this)
    group = "exportarr-prowlarr-exporter"; # confirmed option

    # Extra exporter flags (optional). Example: backfill historical stats.
    # extraFlags = [ "--backfill" "--log-level=INFO" ];
    extraFlags = [
      "--backfill"
      "--log-level=INFO"
    ];
    environment = {}; # confirmed option
    firewallRules = []; # confirmed option
    firewallFilter = null; # confirmed option
  };

  systemd.tmpfiles.rules = [
    # mode uid      gid       age path
    "d /store/prowlarr 0777 prowlarr prowlarr -"
    "z /store/prowlarr 0777 prowlarr prowlarr -"
  ];

  ############################################
  # Systemd hardening fixes for /store/prowlarr
  ############################################
  systemd.services.prowlarr.serviceConfig = {
    # STOP using a random runtime UID; use the stable 'prowlarr' account.
    DynamicUser = lib.mkForce false;
    User = "prowlarr";
    Group = "prowlarr";

    # You already forced -data to /store/prowlarr; keep your override *or*
    # let the module keep its ExecStart. Here we keep your override:
    ExecStart = lib.mkForce "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=/store/prowlarr";

    # Allow writes there despite ProtectSystem and friends.
    ReadWritePaths = ["/store/prowlarr"];
  };

  users.groups.prowlarr = {};

  users.users.prowlarr = {
    isSystemUser = true;
    group = "prowlarr";
    description = "Prowlarr service user";
    home = "/var/lib/prowlarr"; # fine to leave; dataDir is elsewhere
  };

  systemd.services.prometheus-exportarr-prowlarr-exporter.after = ["prowlarr.service"];
  systemd.services.prometheus-exportarr-prowlarr-exporter.requires = ["prowlarr.service"];
  systemd.services.prometheus-exportarr-readarr-exporter.after = ["readarr.service"];
  systemd.services.prometheus-exportarr-readarr-exporter.requires = ["readarr.service"];
}
