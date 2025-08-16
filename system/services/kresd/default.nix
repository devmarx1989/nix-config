{
  config,
  services,
  ...
}: let
  ports = config.my.ports;
  kresd = toString ports.kresd;
  kresdProm = toString ports.kresdProm;
in {
  services.kresd = {
    enable = true;
    instances = 1;
    listenPlain = [
      "0.0.0.0:${kresd}"
    ];
    extraConfig = ''
      --modules.load('predict')
      --modules.load('http')

      cache.size = 10024 * MB

      trust_anchors.remove('.')
      --net.listen('0.0.0.0', ${kresdProm}, { kind = 'webmgmt' })

      --http.prometheus.namespace = 'kresd_'
    '';
  };
}
