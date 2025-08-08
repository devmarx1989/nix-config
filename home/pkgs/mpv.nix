{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    mpvScripts.reload
    mpvScripts.autosub
    mpvScripts.thumbfast
    mpvScripts.twitch-chat
    mpvScripts.youtube-chat
    mpvScripts.sponsorblock
  ];
}
