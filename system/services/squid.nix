{
  config,
  pkgs,
  ...
}: let
  base = "/drive/Store/squid";
  rock = "${base}/rock";
  ufs = "${base}/ufs";
  sslDb = "${base}/ssl_db";
  sslDir = "${base}/ssl";
  sslCrt = "${pkgs.squid}/libexec/squid/ssl_crtd";
in {
  services.squid = {
    enable = true;

    # Use Squid directives (not proxyPort/listenAddress)
    settings = {
      # Bind explicitly
      http_port = "127.0.0.1:3128";
      https_port = [
        "127.0.0.1:3130 ssl-bump cert=${sslDir}/ca.pem generate-host-certificates=on dynamic_cert_mem_cache_size=16MB"
      ];

      cache_mem = "1024 MB";
      maximum_object_size = "512 MB";
      cache_replacement_policy = "heap LFUDA";
      memory_replacement_policy = "heap GDSF";

      # Stores
      cache_dir = [
        "rock ${rock} 1048576 max-size=4194304" # 1 TB, ≤4 MB per object
        "ufs  ${ufs}  2097152 64 256" # 2 TB, big files
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
    };

    # Put ACL and bump policy in one ordered block to avoid “unknown ACL” issues
    extraConfig = ''
      acl localnet src 127.0.0.1/32
      http_access allow localnet
      http_access deny all

      # SSL bump policy
      acl step1 at_step SslBump1
      acl badsites ssl::server_name .bank .paypal.com .microsoft.com .apple.com

      ssl_bump peek step1
      ssl_bump splice badsites
      ssl_bump bump all

      forwarded_for off
      via off
      dns_v4_first on
      pipeline_prefetch on
    '';
  };

  systemd.tmpfiles.rules = [
    "d ${base}   0750 squid squid - -"
    "d ${rock}   0750 squid squid - -"
    "d ${ufs}    0750 squid squid - -"
    "d ${sslDb}  0750 squid squid - -"
    "d ${sslDir} 0700 squid squid - -"
  ];

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
