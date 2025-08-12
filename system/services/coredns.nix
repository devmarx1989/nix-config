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
          bind 0.0.0.0
          bind ::
          forward . 1.1.1.1 8.8.8.8
          prometheus 0.0.0.0:${corednsProm}
          cache {
              success 360000
              denial 30
          }
          log
      }
    '';
  };
}
