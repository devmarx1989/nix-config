{
  home,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    lmstudio
    ollama-cuda
    pinokio
  ];
}
