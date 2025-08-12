{
  config,
  lib,
  pkgs,
  ...
}: let
  ports = config.my.ports;
  proxy = ports.squidProxy;
  bump = toString ports.squidTlsBump; # reuse your port var
in {
  services.squid = {
    enable = true;
    validateConfig = false;

    proxyAddress = "127.0.0.1";
    proxyPort = proxy;

    extraConfig = ''
      # Plain HTTP listener on your "bump" port (keeps same port you’re using)
      http_port 127.0.0.1:${bump}

      # --- ACL & access ---
      acl localnet src 127.0.0.1/32
      http_access allow localnet
      http_access allow localhost
      http_access deny all

      # --- Cache sizing & policy ---
      cache_mem 1024 MB
      maximum_object_size 512 MB
      cache_replacement_policy heap LFUDA
      memory_replacement_policy heap GDSF

      cache_dir rock /drive/Store/squid/rock 1048576 max-size=4194304
      cache_dir ufs  /drive/Store/squid/ufs  2097152 64 256

      range_offset_limit -1
      collapsed_forwarding on
      retry_on_error on
      read_timeout 15 minutes
      connect_timeout 1 minute
      request_timeout 5 minutes

      refresh_pattern -i \.(jpg|jpeg|png|gif|webp|svg|ico|css|js|woff2?)$  1440 90% 43200
      refresh_pattern -i \.(mp4|m4a|mp3|avi|mkv|zip|tar|gz|xz|7z|iso)$     10080 90% 43200
      refresh_pattern .                                                    0    20% 4320

      forwarded_for off
      pipeline_prefetch 1
    '';
  };

  # Make sure /drive is mounted before squid starts
  systemd.services.squid.unitConfig.RequiresMountsFor = ["/drive/Store/squid"];

  # IMPORTANT: remove our ExecStartPre entirely (no ssl_crtd, no CA)
  # If you previously set one, null it out:
  systemd.services.squid.serviceConfig.ExecStartPre = lib.mkForce [];

  # Only create cache parents; no ssl/ssl_db anymore
  systemd.tmpfiles.rules = [
    "d /drive/Store/squid/rock 0750 squid squid - -"
    "d /drive/Store/squid/ufs  0750 squid squid - -"
  ];
}
