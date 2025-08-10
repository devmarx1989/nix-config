{
  config,
  pkgs,
  ...
}: let
  base = "/drive/Store/squid";
  rock = "${base}/rock";
  ufs = "${base}/ufs";
  sslDb = "${base}/ssl_db";
  sslDir = "${base}/ssl"; # if you want CA here too
  sslCrt = "${pkgs.squid}/libexec/squid/ssl_crtd";
in {
  services.squid = {
    enable = true;
    listenAddress = "127.0.0.1";
    proxyPort = 1050; # HTTP + CONNECT passthrough
    settings = {
      cache_mem = "1024 MB";
      maximum_object_size = "512 MB";
      cache_replacement_policy = "heap LFUDA";
      memory_replacement_policy = "heap GDSF";

      # All cache stores on your big drive
      "cache_dir" = [
        "rock ${rock} 1048576 max-size=4194304" # 1 TB, ≤4 MB objects
        "ufs  ${ufs}  2097152 64 256" # 2 TB, large files
      ];

      range_offset_limit = "-1";
      collapsed_forwarding = "on";
      retry_on_error = "on";
      read_timeout = "15 minutes";
      connect_timeout = "1 minute";
      request_timeout = "5 minutes";

      refresh_pattern = [
        "-i \\.(jpg|jpeg|png|gif|webp|svg|ico|css|js|woff2?)$  1440 90% 43200"
        "-i \\.(mp4|m4a|mp3|avi|mkv|zip|tar|gz|xz|7z|iso)$     10080 90% 43200"
        ".                                                     0    20% 4320"
      ];

      # ✅ define ALL ACLs ONCE here
      acl = [
        "localnet src 127.0.0.1/32"
        "step1 at_step SslBump1"
        builtins.concatStringsSep " " [
          "badsites"
          "ssl::server_name" 
          ".bank"
          ".paypal.com"
          ".microsoft.com"
          ".apple.com"
          ".bankofamerica.com"
        ]
      ];

      http_access = ["allow localnet" "deny all"];

      # HTTPS bumping port (cacheable TLS)
      https_port = [
        "3130 ssl-bump cert=${sslDir}/ca.pem generate-host-certificates=on dynamic_cert_mem_cache_size=16MB"
      ];
      sslcrtd_program = "${sslCrt} -s ${sslDb} -M 16MB";
      sslcrtd_children = "5 startup=1 idle=1";

      tls_outgoing_options = "min=TLS1.2";
      sslproxy_options = "ALL:NO_COMPRESSION";

      # Splice pinned/HSTS sites; bump the rest
      ssl_bump = ["peek step1" "splice badsites" "bump all"];

      forwarded_for = "off";
      via = "off";
      dns_v4_first = "on";
      pipeline_prefetch = "on";
    };
  };

  systemd.tmpfiles.rules = [
    "d ${base} 0750 squid squid - -"
    "d ${rock} 0750 squid squid - -"
    "d ${ufs}  0750 squid squid - -"
    "d ${sslDb} 0750 squid squid - -"
    "d ${sslDir} 0700 squid squid - -"
  ];

  # Initialize ssl_db and create a CA if missing (stored under your drive)
  systemd.services.squid.preStart = ''
    if [ ! -d "${sslDb}" ] || [ ! -f "${sslDb}/cert9.db" ]; then
      ${sslCrt} -c -s ${sslDb}
    fi
    if [ ! -f ${sslDir}/ca.pem ]; then
      umask 077
      openssl req -x509 -new -nodes -newkey rsa:4096 -sha256 -days 3650 \
        -subj "/CN=Squid Local MITM CA" \
        -keyout ${sslDir}/ca.key -out ${sslDir}/ca.pem
      chown squid:squid ${sslDir}/ca.key ${sslDir}/ca.pem
      chmod 0600 ${sslDir}/ca.key
    fi
  '';
}
