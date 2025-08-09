{pkgs, ...}: {
  home.packages = with pkgs; [
    amass
    aria2
    avahi
    curl
    expressvpn
    masscan
    newsboat
    nmap
    pup
    rustscan
    unixtools.netstat
    wget
    yt-dlp
    zdns
    zmap
  ];
}
