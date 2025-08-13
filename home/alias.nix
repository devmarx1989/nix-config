{
  config,
  pkgs,
  ports,
  ...
}: let
  ipfs = toString ports.ipfs3;
in {
  home.shellAliases = {
    "..." = "cd ../..";
    "...." = "cd ../../../";
    "nb" = "newsboat --cache-file=./cache.db --url-file=./urls --log-file=./output.log --log-level=5";
    "ipfs" = "ipfs --api /ip4/127.0.0.1/tcp/${ipfs}";
  };
}
