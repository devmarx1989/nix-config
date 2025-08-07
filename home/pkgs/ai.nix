{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    lmstudio
    pinokio
    #aider-chat-full
  ];
}
