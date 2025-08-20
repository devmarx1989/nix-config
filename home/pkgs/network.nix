{pkgs, ...}: {
  home.packages = with pkgs; [
    amass
    aria2
    avahi
    curl
    expressvpn
    iroh
    localsend
    masscan
    nethogs
    newsboat
    nmap
    pup
    rustscan
    sniffnet
    unixtools.netstat
    wget
    yt-dlp
    zdns
    zmap
  ];
}
