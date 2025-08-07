{ services, pkgs, ... }:

{
  services.avahi = {
    enable = true;

    # Use a custom package (optional, usually default is fine)
    #package = pkgs.avahi;

    # Allow Avahi to bind to all interfaces
    allowInterfaces = [ ];
    denyInterfaces = [ ];
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

    # Extra configuration (goes into avahi-daemon.conf)
    extraConfig = ''
      use-ipv6=yes
      use-ipv4=yes
      enable-dbus=yes
    '';

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
    extraServiceFiles = [
      (pkgs.writeText "ssh.service" ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h SSH</name>
          <service>
            <type>_ssh._tcp</type>
            <port>22</port>
          </service>
        </service-group>
      '')
      (pkgs.writeText "sftp.service" ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h SFTP</name>
          <service>
            <type>_sftp-ssh._tcp</type>
            <port>22</port>
          </service>
        </service-group>
      '')
    ];

    # Extra domains to browse for services
    browseDomains = [ "local" "example.local" ];

    # Override the default domain (optional)
    domainName = "local";

    # Max number of entries in mDNS cache
    cacheEntriesMax = 4096;
  };
}

