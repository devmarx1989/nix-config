{
  services,
  pkgs,
  ...
}: {
  services.avahi = {
    enable = true;

    # Use a custom package (optional, usually default is fine)
    #package = pkgs.avahi;

    # Allow Avahi to bind to all interfaces
    allowInterfaces = [];
    denyInterfaces = [];
    allowPointToPoint = true;

    # Use both IPv4 and IPv6
    ipv4 = true;
    ipv6 = true;

    # Enable nss-mdns for .local hostname resolution
    nssmdns4 = true;
    nssmdns6 = true;

    # Optional: Set custom hostname (omit to use system's hostname)
    hostName = "house-of-marx";

    # Enable wide-area DNS-SD (WAN service discovery)
    wideArea = true;

    # Reflect mDNS packets between interfaces (e.g., Ethernet <-> Wi-Fi)
    reflector = true;

    # Open firewall ports for mDNS/Avahi
    #openFirewall = true;

    # Service publishing
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      workstation = true;
      userServices = true;
      hinfo = true;
    };

    # Add extra service advertisements (example: SSH and SFTP)
    extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    }; # Extra domains to browse for services
    browseDomains = ["local" "example.local"];

    # Override the default domain (optional)
    domainName = "local";

    # Max number of entries in mDNS cache
    cacheEntriesMax = 4096;
  };
}
