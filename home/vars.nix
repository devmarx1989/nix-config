{ pkgs, ... }:
{
  home.sessionVariables = {
    CC = "sccache clang";
    CXX = "scacche clang++";
    MAX_JOBS = "16";
    EDITOR = "nvim";
    GOPATH = "~/Go";
    LANG = "C.UTF-8";
    MCFLY_FUZZY = "2";
    MCFLY_KEY_SCHEME = "vim";
    NIXPKGS_ALLOW_UNFREE = "1";
    OPS_DIR = "~/.ops";
    PAGER = "bat";
    PNPM_HOME = "~/.local/share/pnpm";
    PYTHONIOENCODING = "UTF-8";
    RUSTC_WRAPPER = "sccache";
    RUST_BACKTRACE = "full";
    RYE_UV_BINARY = "${pkgs.uv}/bin/uv";
    SBT_OPTS = "-Xms16G -Xmx32G";
    SCCACHE_CACHE_SIZE = "100G";
    TZ = "America/Mexico_City";
    VDIFF_TOOL = "delta";
    VISUAL = "nvim";
    WASMER_DIR = "~/Wasmer";
  };
}
