{ pkgs, ... }:
{
  home.packages = with pkgs; [
    amass
    aria2
    curl
    expressvpn
    masscan
    nmap
    unixtools.netstat
    rustcan
    pup
    wget
    zdns
    newsboat
    zmap
    yt-dlp
  ];
}
