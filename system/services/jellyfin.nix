{
  config,
  services,
  ...
}: let
  ports = config.my.ports;
  http = toString ports.jellyfinHttp;
  https = toString ports.jellyfinHttps;
in {
  services.jellyfin = {
    enable = true;
    group = "jellyfin";
    user = "jellyfin";
    dataDir = "/store/jellyfin";
    logDir = "/store/jellyfin/log";
    cacheDir = "/store/jellyfin/cache";
  };

  systemd.services.jellyfin.unitConfig.RequiresMountsFor = ["/store/jellyfin"];

  # Only create cache parents; no ssl/ssl_db anymore
  systemd.tmpfiles.rules = [
    "d /store/jellyfin   0777 jellyfin jellyfin - -"
    "d /store/jellyfin/log   0777 jellyfin jellyfin - -"
    "d /store/jellyfin/cache   0777 jellyfin jellyfin - -"
  ];
}
