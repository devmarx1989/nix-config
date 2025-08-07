{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    #aider-chat-full
    llama-cpp
    lmstudio
    ollama-cuda
    pinokio
    whisper-cpp
    whisperx
  ];
}
