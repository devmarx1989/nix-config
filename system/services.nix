{ services, ...}:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  
   # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dev-marx";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.ntp.enable = false;
  services.timesyncd = {
    enable = true;
    servers = [
      "0.mx.pool.ntp.org"
      "1.mx.pool.ntp.org"
      "2.mx.pool.ntp.org"
      "3.mx.pool.ntp.org"
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
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
  services.coredns = {
    enable = true;

    config = ''
      .:1001 {
          bind 0.0.0.0
          bind ::
          forward . 1.1.1.1 8.8.8.8
          cache {
              success 360000
              denial 30
          }
          log
      }
    '';
  };
  services.openssh.enable = true;
  services.expressvpn.enable = true;
  services.resolved.enable = true;
}
