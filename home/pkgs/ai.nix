{
  home,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    docling
    lmstudio
    ollama-cuda
    pinokio
    whisperx
  ];
}
