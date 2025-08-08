{pkgs, ...}: {
  home.shellAliases = {
    "..." = "cd ../..";
    "...." = "cd ../../../";
    "nb" = "newsboat --cache-file=./cache.db --url-file=./urls --log-file=./output.log --log-level=5";
  };
}
