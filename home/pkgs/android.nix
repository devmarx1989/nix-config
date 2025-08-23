{pkgs, ...}: {
  home.packages = with pkgs; [
    android-tools
    android-studio-tools
    android-studio-full
  ];
}
