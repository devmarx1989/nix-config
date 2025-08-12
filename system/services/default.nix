{services, ...}: {
  imports = [
    ./avahi.nix
    ./coredns.nix
    ./ipfs.nix
    ./jellyfin.nix
    ./grafana.nix
    ./loki.nix
    ./ollama.nix
    ./prometheus.nix
    ./promtail.nix
    ./squid.nix
    ./systemd-drive.nix
    ./systemd-store.nix
  ];

  security.rtkit.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dev-marx";
  services.displayManager.gdm.enable = true;
  services.expressvpn.enable = true;
  services.ntp.enable = false;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  services.resolved.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.timesyncd = {
    enable = true;
    servers = [
      "0.mx.pool.ntp.org"
      "1.mx.pool.ntp.org"
      "2.mx.pool.ntp.org"
      "3.mx.pool.ntp.org"
    ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
