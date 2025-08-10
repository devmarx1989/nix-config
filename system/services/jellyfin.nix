{services, ...}: {
  services.jellyfin = {
    enable = true;
    group = "jellyfin";
    user = "jellyfin";
    dataDir = "/store/jellyfin";
    logDir = "/store/jellyfin/log";
    cacheDir = "/store/jellyfin/cache";
  };
}
