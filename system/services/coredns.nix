{
  networking,
  config,
  services,
  ...
}: let
  ports = config.my.ports; # optional convenience alias
  coredns = toString 53;
  corednsProm = toString ports.corednsProm;
in {
  services.coredns = {
    enable = true;

    config = ''
      .:${coredns} {
          debug
          log
          errors
          whoami
          bind 0.0.0.0
          bind ::
          prometheus 0.0.0.0:${corednsProm}

          forward . 1.1.1.1 1.0.0.1 8.8.4.4 8.8.8.8 9.9.9.9 208.67.222.222 208.67.220.220 149.112.112.112 {
            force_tcp
            policy random
            health_check 1s
            max_concurrent 1000
            max_fails 5
            expired 10s
          }
          cache {
              success 360000
              denial 1
              prefetch 50 1m
              serve_stale 1h
              keepttl
          }
      }
    '';
  };
}
