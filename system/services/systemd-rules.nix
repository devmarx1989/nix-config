{
  systemd,
  lib,
  ...
}: let
  # 1) list of service names (strings)
  serviceNames = [
    "loki"
    "prometheus"
    "promtail"
    "grafana"
  ];

  # 2) helper to build { name = "<name>"; }
  mk = name: {inherit name;};

  # 3) turn names into [{ name = "..."; } ...]
  services = map mk serviceNames;
in {
  systemd.tmpfiles.rules =
    map (svc: "d /store/${svc.name} 0755 ${svc.name} ${svc.name} -") services;

  systemd.services =
    lib.genAttrs serviceNames
    (name: {serviceConfig.WorkingDirectory = lib.mkForce "/store/${name}";});
}
