{pkgs, ...}: {
  home.sessionVariables = {
    GOPATH = "~/Go";
    OPS_DIR = "~/.ops";
    PNPM_HOME = "~/.local/share/pnpm";
    WASMER_DIR = "~/Wasmer";
  };
}
