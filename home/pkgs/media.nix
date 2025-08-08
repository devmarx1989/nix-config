{pkgs, ...}: {
  home.packages = with pkgs; [
    feh
    ffmpeg-full
    foliate
    mediainfo
    mupdf
    vlc
  ];
}
