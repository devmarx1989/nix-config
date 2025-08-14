{
  networking,
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

          forward . 1.1.1.1 8.8.8.8 9.9.9.9 {
            policy random
            max_fails 2
            health_check 10s
          }
          cache {
              success 360000
              denial 30
              prefetch 5 1000h
              serve_stale 1h
          }
      }
    '';
  };

  services.resolved = {
    enable = true;
    dns = ["127.0.0.1#${coredns}"];
    domains = ["~."];
    fallbackDns = [];
  };

  networking = {
    networkingmanager.dns = "systemd-resolved";
    resolvconf.extraConfig = "options timeout:1 attempts:1";
  };
}
