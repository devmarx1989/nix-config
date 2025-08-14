{
  config,
  services,
  ...
}: let
  port = config.my.ports.calibreServer;
in {
  services.calibre-server = {
    enable = true;

    # Server identity
    user = "calibre";
    group = "calibre";

    # Networking
    port = port;
    host = "0.0.0.0";

    # Authentication
    auth.enable = false;

    # Package
    package = pkgs.calibre;

    # Library paths
    libraries = [
      "/drive/Libs/archive"
      "/drive/Libs/biblioteca"
      "/drive/Libs/comics"
      "/drive/Libs/computersci"
      "/drive/Libs/fiction"
      "/drive/Libs/govdocs"
      "/drive/Libs/main"
      "/drive/Libs/portuguese"
      "/drive/Libs/spanish"
      "/drive/Libs/technical"
    ];

    # Extra flags for calibre-server
    extraFlags = [
      "--trusted-ips=127.0.0.1"
      "--timeout=120"
      "--url-prefix=/calibre"
    ];
  };

  # Create calibre user/group
  users.users.calibre = {
    isSystemUser = true;
    group = "calibre";
    home = "/var/lib/calibre-server";
    createHome = true;
  };

  users.groups.calibre = {};
}
