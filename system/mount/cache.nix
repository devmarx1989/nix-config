{
  lib,
  config,
  pkgs,
  ...
}: let
  # just change this list when you want new cache dirs mounted
  cacheDirs = [
    "huggingface"
    "uv"
  ];
in {
  # Ensure dirs exist with 0777
  systemd.tmpfiles.rules =
    ["d /home/dev-marx/.cache 0777 dev-marx users -"]
    ++ (map (d: "d /home/dev-marx/.cache/${d} 0777 dev-marx users -") cacheDirs)
    ++ (map (d: "d /drive/cache/${d} 0777 dev-marx users -") cacheDirs);

  # Bind mounts for each dir
  fileSystems = builtins.listToAttrs (map (d: {
      name = "/home/dev-marx/.cache/${d}";
      value = {
        device = "/drive/cache/${d}";
        fsType = "none";
        options = ["bind"];
      };
    })
    cacheDirs);
}
