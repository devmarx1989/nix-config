{ services, ...}:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  services.bind = {
    enable = true;
    listenOn = [
      "::1"
      "127.0.0.1"
      "localhost"
    ];

    listenOnIpv6 = [ "::1" ];
    forwarders = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
    cacheNetworks = [
      "127.0.0.0/24"
      "::1/128"
    ];
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
  services.openssh.enable = true;
  services.expressvpn.enable = true;
}
