{pkgs, ...}: {
  home.packages = with pkgs; [
    gh
    internetarchive
    kaggle
  ];
}
