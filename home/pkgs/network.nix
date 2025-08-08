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
    rustscan
    unixtools.netstat
    wget
    yt-dlp
    zdns
    zmap
  ];
}
