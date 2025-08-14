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
          bind 0.0.0.0
          bind ::
          prometheus 0.0.0.0:${corednsProm}
        	timeouts {
            read 40s
            write 80s
            idle 240s
          }

          forward . 1.1.1.1 1.0.0.1 8.8.4.4 8.8.8.8 9.9.9.9 208.67.222.222 208.67.220.220 149.112.112.112 {
            policy random
            max_fails 2
            health_check 10s
          }
          cache {
              success 360000
              denial 30
              prefetch 10 1000h
              serve_stale 1h
          }
      }
    '';
  };

  networking = {
    #networkmanager.dns = "systemd-resolved";
    resolvconf.extraConfig = "options timeout:1 attempts:1";
  };
}
