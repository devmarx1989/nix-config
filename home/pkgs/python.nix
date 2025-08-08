{pkgs, ...}: {
  home.packages = with pkgs; [
    rye
    uv
    ruff
    ty
  ];
}
