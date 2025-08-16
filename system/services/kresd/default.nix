{
  config,
  pkgs,
  lib,
  ...
}: let
  ports = config.my.ports;
  kresdPort = toString ports.kresd;
  kresdProm = toString ports.kresdProm;

  # LuaJIT packages we need for the HTTP module
  lp = pkgs.luajitPackages;
  luaPkgs = [
    (lp.cqueues or lp.lua-cqueues)
    (lp.http    or lp.lua-http)
  ];

  luaPath = pkgs.lib.makeSearchPath "share/lua/5.1" luaPkgs;
  luaCPath = pkgs.lib.makeSearchPath "lib/lua/5.1" luaPkgs;

  # Wrap kresd so LUA_PATH/LUA_CPATH include the modules
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
    enable = true;
    package = kresdWrapped; # <-- use the wrapped binary
    instances = 1;

    # Use kresd's native address syntax (host@port). Dual-stack is fine.
    listenPlain = [
      "0.0.0.0@${kresdPort}"
      "[::]@${kresdPort}"
    ];

    extraConfig = ''
      -- enable useful modules
      modules.load('predict')
      modules.load('http')

      -- big cache
      cache.size = 10024 * MB

      -- don't auto-load root trust anchors (you explicitly removed '.')
      trust_anchors.remove('.')

      -- expose webmgmt + Prometheus /metrics
      net.listen('0.0.0.0', ${kresdProm}, { kind = 'webmgmt' })
      http.prometheus.namespace = 'kresd_'
    '';
  };
}
