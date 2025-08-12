{
  config,
  services,
  pkgs,
  lib,
  ...
}: let
  ports = config.my.ports;
  proxy = ports.squidProxy;
  bump = toString ports.squidTlsBump;
in {
  services.squid = {
    enable = true;
    validateConfig = false;

    proxyAddress = "127.0.0.1";
    proxyPort = proxy;

    extraConfig = ''
      # --- TLS-bump listener on 3130 ---
      http_port 127.0.0.1:${bump} ssl-bump \
        cert=/drive/Store/squid/ssl/ca.pem \
        key=/drive/Store/squid/ssl/ca.key \
        generate-host-certificates=on \
        dynamic_cert_mem_cache_size=16MB

      sslcrtd_program ${pkgs.squid}/libexec/squid/ssl_crtd -s /drive/Store/squid/ssl_db -M 16MB
      sslcrtd_children 5

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

      forwarded_for off
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
        set -euo pipefail

        # Ensure directories exist (tmpfiles runs at boot, but be safe)
        install -d -m 0750 -o squid -g squid /drive/Store/squid/rock /drive/Store/squid/ufs /drive/Store/squid/ssl_db
        install -d -m 0700 -o squid -g squid /drive/Store/squid/ssl

        # Init ssl_db if missing
        if [ ! -f /drive/Store/squid/ssl_db/cert9.db ]; then
          ${pkgs.squid}/libexec/squid/ssl_crtd -c -s /drive/Store/squid/ssl_db
          chown -R squid:squid /drive/Store/squid/ssl_db
          chmod 0750 /drive/Store/squid/ssl_db
        fi

        # Function: create a proper CA cert (CA:TRUE)
        create_ca() {
          umask 077
          cfg=/run/squid-openssl.cnf
          cat > "$cfg" <<'EOF'
    [ req ]
    distinguished_name = dn
    x509_extensions = v3_ca
    prompt = no
    [ dn ]
    CN = Squid Local MITM CA
    [ v3_ca ]
    basicConstraints = critical, CA:true, pathlen:0
    keyUsage = critical, keyCertSign, cRLSign
    subjectKeyIdentifier = hash
    authorityKeyIdentifier = keyid:always,issuer
    EOF
          ${pkgs.openssl}/bin/openssl req -x509 -new -nodes -newkey rsa:4096 -sha256 -days 3650 \
            -config "$cfg" -extensions v3_ca \
            -keyout /drive/Store/squid/ssl/ca.key \
            -out /drive/Store/squid/ssl/ca.pem
          chown squid:squid /drive/Store/squid/ssl/ca.key /drive/Store/squid/ssl/ca.pem
          chmod 0600 /drive/Store/squid/ssl/ca.key
        }

        need_new_ca=0
        if [ ! -f /drive/Store/squid/ssl/ca.pem ] || [ ! -f /drive/Store/squid/ssl/ca.key ]; then
          need_new_ca=1
        else
          if ! ${pkgs.openssl}/bin/openssl x509 -in /drive/Store/squid/ssl/ca.pem -noout -text | grep -q 'CA:TRUE'; then
            need_new_ca=1
          fi
        fi

        if [ "$need_new_ca" -eq 1 ]; then
          create_ca
        fi
  '';
}
