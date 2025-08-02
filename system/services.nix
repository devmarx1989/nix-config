{ services, ...}:
{
  services.coredns = {
    enable = true;

    config = ''
      . {
          bind 0.0.0.0
          bind [::]
          forward . 1.1.1.1
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
