{
  config,
  lib,
  pkgs,
  ...
}: let
  ports = config.my.ports;
  proxy = ports.squidProxy;
  bump = toString ports.squidTlsBump;

  # Helper wrapper: picks the available cert generator on this system
  sslcrtdWrapper = pkgs.writeShellScriptBin "squid-sslcrtd" ''
    set -euo pipefail

    # 1) Fast path: common locations
    for name in ssl_crtd security_file_certgen; do
      for dir in \
        "${pkgs.squid}/libexec" \
        "${pkgs.squid}/libexec/squid" \
        "${pkgs.squid}/lib" \
        "${pkgs.squid}/lib/squid" \
        "${pkgs.squid}/bin" \
        "${pkgs.squid}/sbin"
      do
        if [ -x "$dir/$name" ]; then
          exec "$dir/$name" "$@"
        fi
      done
    done

    # 2) Fallback: search the whole store path for an executable named like the helpers
    found="$(${pkgs.findutils}/bin/find "${pkgs.squid}" -type f \( -name ssl_crtd -o -name security_file_certgen \) -perm -111 -print -quit || true)"
    if [ -n "$found" ]; then
      exec "$found" "$@"
    fi

    echo "ERROR: Could not find squid ssl cert helper (ssl_crtd/security_file_certgen) in ${pkgs.squid}" >&2
    exit 127
  '';
  sslcrtd_cmd = "${sslcrtdWrapper}/bin/squid-sslcrtd";

  # Run before the module’s own ExecStartPre
  squidPrep = pkgs.writeShellScript "squid-prep.sh" ''
        set -euo pipefail

        install -d -m 0750 -o squid -g squid /drive/Store/squid
        install -d -m 0750 -o squid -g squid /drive/Store/squid/{rock,ufs,ssl_db}
        install -d -m 0700 -o squid -g squid /drive/Store/squid/ssl

        # Initialize ssl_db once
        if [ ! -f /drive/Store/squid/ssl_db/cert9.db ]; then
          ${sslcrtd_cmd} -c -s /drive/Store/squid/ssl_db
          chown -R squid:squid /drive/Store/squid/ssl_db
          chmod 0750 /drive/Store/squid/ssl_db
        fi

        # Ensure we have a CA with CA:TRUE
        need_new_ca=0
        if [ ! -s /drive/Store/squid/ssl/ca.pem ] || [ ! -s /drive/Store/squid/ssl/ca.key ]; then
          need_new_ca=1
        elif ! ${pkgs.openssl}/bin/openssl x509 -in /drive/Store/squid/ssl/ca.pem -noout -text | grep -q 'CA:TRUE'; then
          need_new_ca=1
        fi

        if [ "$need_new_ca" -eq 1 ]; then
          umask 077
          cfg="$(mktemp)"
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
            -out   /drive/Store/squid/ssl/ca.pem
          chown squid:squid /drive/Store/squid/ssl/ca.key /drive/Store/squid/ssl/ca.pem
          chmod 0600 /drive/Store/squid/ssl/ca.key
          rm -f "$cfg"
        fi
  '';
in {
  services.squid = {
    enable = true;
    validateConfig = false;

    proxyAddress = "127.0.0.1";
    proxyPort = proxy;

    extraConfig = ''
      # --- TLS-bump listener ---
      http_port 127.0.0.1:${bump} ssl-bump \
        cert=/drive/Store/squid/ssl/ca.pem \
        key=/drive/Store/squid/ssl/ca.key \
        generate-host-certificates=on \
        dynamic_cert_mem_cache_size=16MB

      # Use wrapper so path variations are handled
      sslcrtd_program ${sslcrtd_cmd} -s /drive/Store/squid/ssl_db -M 16MB
      sslcrtd_children 5

      # --- ACL & access ---
      acl localnet src 127.0.0.1/32
      http_access allow localnet
      http_access allow localhost
      http_access deny all

      # SSL bump policy
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

  # ! important: RequiresMountsFor is a [Unit] key
  systemd.services.squid.unitConfig.RequiresMountsFor = ["/drive/Store/squid"];

  # Ensure our prep runs before the module's own ExecStartPre
  systemd.services.squid.serviceConfig.ExecStartPre = lib.mkBefore [squidPrep];

  # Keep tmpfiles (harmless if prep already made them)
  systemd.tmpfiles.rules = [
    "d /drive/Store/squid/rock   0750 squid squid - -"
    "d /drive/Store/squid/ufs    0750 squid squid - -"
    "d /drive/Store/squid/ssl_db 0750 squid squid - -"
    "d /drive/Store/squid/ssl    0700 squid squid - -"
  ];
}
