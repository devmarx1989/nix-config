{
  pkgs,
  ports,
  ...
}: let
  ipfs = toString ports.ipfs3;
in {
  home.shellAliases = {
    "..." = "cd ../..";
    "...." = "cd ../../../";
    "nb" = "newsboat --conf-file=~/.newsboat/conf --cache-file=./cache.db --url-file=./urls --log-file=./output.log --log-level=5";
  };
}
