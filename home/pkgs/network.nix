{pkgs, ...}: {
  home.packages = with pkgs; [
    amass
    aria2
    avahi
    curl
    expressvpn
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
