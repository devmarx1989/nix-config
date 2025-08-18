{
  config,
  pkgs,
  lib,
  ...
}: let
  ports = config.my.ports;
  kresdPort = toString ports.kresd;
  kresdProm = toString ports.kresdProm;

  # LuaJIT packages needed by kresd's 'http' module
  lp = pkgs.luajitPackages;
  luaPkgs = [
    (lp.cqueues or lp.lua-cqueues)
    (lp.http    or lp.lua-http)
  ];

  luaPath = pkgs.lib.makeSearchPath "share/lua/5.1" luaPkgs;
  luaCPath = pkgs.lib.makeSearchPath "lib/lua/5.1" luaPkgs;

  # Wrap kresd so LUA_PATH/LUA_CPATH include required modules
  kresdWrapped = pkgs.symlinkJoin {
    name = "knot-resolver-with-http";
    paths = [pkgs.knot-resolver];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/kresd \
        --set-default LUA_PATH  "$LUA_PATH;${luaPath}/?.lua;${luaPath}/?/init.lua" \
        --set-default LUA_CPATH "$LUA_CPATH;${luaCPath}/?.so"
    '';
  };
in {
  services.kresd = {
    enable = false;
    package = kresdWrapped;
    instances = 1;

    # NixOS module expects host:port / [::]:port here
    listenPlain = [
      "0.0.0.0:${kresdPort}"
      "[::]:${kresdPort}"
    ];

    extraConfig = ''
      modules.load('predict')
      modules.load('http')

      cache.size = 10024 * MB

      trust_anchors.remove('.')

      -- Web management + Prometheus (/metrics) on kresdProm
      net.listen('0.0.0.0', ${kresdProm}, { kind = 'webmgmt' })
      http.prometheus.namespace = 'kresd_'
    '';
  };
}
