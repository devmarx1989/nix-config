{systemd, ...}: {
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  systemd.services.nix-daemon.serviceConfig = {
    CPUQuota = "400%";     # cap at half a CPU worth per core set
    CPUWeight = 200;      # de-prioritize vs. interactive apps
    IOWeight = 200;       # friendlier disk usage
    MemoryMax = "8G";     # hard memory ceiling for builds
  };
}
