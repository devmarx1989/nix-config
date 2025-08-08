{
  pkgs,
  myPkgs,
  ...
}: {
  home.packages = builtins.attrValues myPkgs;
}
