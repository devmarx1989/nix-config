{
  config,
  services,
  ...
}: let
  ports = config.my.ports; # optional convenience alias
  coredns = toString ports.coredns;
  corednsProm = toString ports.corednsProm;
in {
  services.coredns = {
    enable = true;

    config = ''
      .:${coredns} {
          debug
          log
          errors
          bind 0.0.0.0
          bind ::
          prometheus 0.0.0.0:${corednsProm}

          fanout . 1.1.1.1 8.8.8.8 9.9.9.9 {
            policy random
            max_fails 2
            health_check 10s
            timeout 8s
          }
          cache {
              success 360000
              denial 30
              prefetch 5 1000
              serve_stale 1h
          }
      }
    '';
  };
}
