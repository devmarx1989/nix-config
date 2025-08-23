{
  config,
  environment,
  pkgs,
  ...
}: let
  ports = config.my.ports;
  ollama = toString ports.ollama;
  ipfs = toString ports.ipfs3;
in {
  environment.systemPackages = (
    with pkgs;
      (with pkgs.cudaPackages; [
        cudatoolkit
        cudnn
      ])
      ++ [
        ccache
        sccache
      ]
  );

  environment.shellAliases = {
    "ipfs" = "ipfs --api /ip4/127.0.0.1/tcp/${ipfs}";
  };

  # For GUI apps using GPU (WSLg)
  environment.variables = {
    CC = "sccache clang";
    CMAKE_CUDA_ARCHITECTURES = "86";
    CMAKE_CXX_COMPILER_LAUNCHER = "sccache";
    CMAKE_C_COMPILER_LAUNCHER = "sccache";
    CUDAARCHS = "86";
    CXX = "scacche clang++";
    EDITOR = "nvim";
    GTK_ENABLE_PRIMARY_PASTE = "1";
    LIBGL_ALWAYS_INDIRECT = "1";
    MAX_JOBS = "16";
    MCFLY_FUZZY = "2";
    MCFLY_KEY_SCHEME = "vim";
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = "1";
    OLLAMA_HOST = "127.0.0.1:${ollama}";
    PAGER = "bat";
    PYTHONIOENCODING = "UTF-8";
    RUSTC_WRAPPER = "sccache";
    RUST_BACKTRACE = "full";
    RYE_UV_BINARY = "${pkgs.uv}/bin/uv";
    SBT_OPTS = "-Xms16G -Xmx32G";
    SCCACHE_CACHE_SIZE = "100G";
    SCCACHE_DIR = "/store/sccache";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    TORCH_CUDA_ARCH_LIST = "8.6";
    TZ = "America/Mexico_City";
    VDIFF_TOOL = "delta";
    VISUAL = "nvim";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
