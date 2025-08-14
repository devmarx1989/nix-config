{
  lib,
  config,
  systemd,
  ...
}: let
  proxy = toString config.my.ports.squidProxy;
in {
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
      ollama.wantedBy = lib.mkForce [];
      nix-daemon = {
        serviceConfig = {
          CPUQuota = "1600%"; # cap at half a CPU worth per core set
          CPUWeight = 200; # de-prioritize vs. interactive apps
          IOWeight = 200; # friendlier disk usage
          MemoryMax = "20G"; # hard memory ceiling for builds
        };
        environment = {
          #http_proxy = "http://127.0.0.1:${proxy}";
          # https_proxy = "http://127.0.0.1:10024"; # only if you want HTTPS via proxy
          #no_proxy = lib.mkForce "localhost,127.0.0.1,::1";
        };
      };
    };
  };
}
