{pkgs, ...}: {
  home.packages = with pkgs; [
    amass
    aria2
    curl
    expressvpn
    masscan
    newsboat
    nmap
    pup
    subliminal
    rustcan
    unixtools.netstat
    wget
    yt-dlp
    zdns
    zmap
  ];
}
