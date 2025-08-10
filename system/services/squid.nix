{
  services,
  pkgs,
  ...
}: {
  services.squid = {
    enable = true;

    # Make the builder stop running `squid -k parse` (files are created at runtime)
    validateConfig = false;

    proxyAddress = "127.0.0.1";
    proxyPort = 3128;

    extraConfig = ''
      # --- Ports ---
      # 3128 from proxyAddress/proxyPort above
      http_port 127.0.0.1:3130 ssl-bump \
        cert=/drive/Store/squid/ssl/ca.pem \
        generate-host-certificates=on \
        dynamic_cert_mem_cache_size=16MB

      # --- ACL & access ---
      acl localnet src 127.0.0.1/32
      http_access allow localnet
      http_access allow localhost
      http_access deny all

      # SSL bump policy (order matters)
      acl step1 at_step SslBump1
      acl badsites ssl::server_name .bank .paypal.com .microsoft.com .apple.com
      ssl_bump peek step1
      ssl_bump splice badsites
      ssl_bump bump all

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

      # QoL
      forwarded_for off
      # via off        # optional; leaving it off will log a warning
      pipeline_prefetch 1
    '';
  };

  systemd.tmpfiles.rules = [
    "d /drive/Store/squid/rock   0750 squid squid - -"
    "d /drive/Store/squid/ufs    0750 squid squid - -"
    "d /drive/Store/squid/ssl_db 0750 squid squid - -"
    "d /drive/Store/squid/ssl    0700 squid squid - -"
  ];

  systemd.services.squid.preStart = ''
    # init ssl_db
    if [ ! -d /drive/Store/squid/ssl_db ] || [ ! -f /drive/Store/squid/ssl_db/cert9.db ]; then
      ${pkgs.squid}/libexec/squid/ssl_crtd -c -s /drive/Store/squid/ssl_db
    fi
    # create local CA if missing
    if [ ! -f /drive/Store/squid/ssl/ca.pem ]; then
      umask 077
      openssl req -x509 -new -nodes -newkey rsa:4096 -sha256 -days 3650 \
        -subj "/CN=Squid Local MITM CA" \
        -keyout /drive/Store/squid/ssl/ca.key -out /drive/Store/squid/ssl/ca.pem
      chown squid:squid /drive/Store/squid/ssl/ca.key /drive/Store/squid/ssl/ca.pem
      chmod 0600 /drive/Store/squid/ssl/ca.key
    fi
  '';
}
