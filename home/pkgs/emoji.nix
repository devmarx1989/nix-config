{pkgs, ...}: {
  home.packages = with pkgs; [
    emoji-picker
    emojify
    emojione
    emojipick
    emote
    xmoji
  ];
}
