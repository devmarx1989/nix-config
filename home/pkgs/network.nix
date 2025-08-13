{pkgs, ...}: {
  home.packages = with pkgs; [
    amass
    aria2
    avahi
    curl
    expressvpn
    localsend
    masscan
    nethogs
    newsboat
    nmap
    pup
    sniffnet
    rustscan
    unixtools.netstat
    wget
    yt-dlp
    zdns
    zmap
  ];
}
