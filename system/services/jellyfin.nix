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
}
