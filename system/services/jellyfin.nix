{config, services, ...}:
let
  ports = config.my.ports;
  http = toString ports.jellyfinHttp;
  https = toString ports.jellyfinHttps;
{
  services.jellyfin = {
    enable = true;
    group = "jellyfin";
    user = "jellyfin";
    dataDir = "/store/jellyfin";
    logDir = "/store/jellyfin/log";
    cacheDir = "/store/jellyfin/cache";
    extraArgs = [
      "--listen=0.0.0.0"        # listen on all interfaces
      "--publicPort=${http}"       # change this to your desired port
      "--publicHttpsPort=${https}"  # change HTTPS port
    ];
  };
}
