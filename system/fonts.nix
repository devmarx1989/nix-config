{
  config,
  lib,
  pkgs,
  fonts,
  ...
}: let
  nfs =
    builtins.filter lib.attrsets.isDerivation # keep derivations only
    
    (builtins.attrValues pkgs.nerd-fonts);
in {
  # Fonts
  fonts.packages = with pkgs;
    [
      atkinson-hyperlegible
      dina-font
      fira-code
      fira-code-symbols
      liberation_ttf
      monaspace
      mplus-outline-fonts.githubRelease
      noto-fonts-cjk-sans
      noto-fonts-emoji
      proggyfonts
    ]
    ++ nfs;
}
