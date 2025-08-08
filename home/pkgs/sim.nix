{pkgs, ...}: {
  home.packages = with pkgs; [
    elastic
  ];
}
