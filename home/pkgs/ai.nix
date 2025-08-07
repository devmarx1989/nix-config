{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    #aider-chat-full
    lmstudio
    ollama-cuda
    pinokio
    whisperx
  ];
}
