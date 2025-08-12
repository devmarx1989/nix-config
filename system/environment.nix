{
  environment,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs.cudaPackages; [
    ccache
    cudatoolkit
    cudnn
  ];

  # For GUI apps using GPU (WSLg)
  environment.variables = {
    CMAKE_CUDA_ARCHITECTURES = "86";
    CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
    CMAKE_CXX_COMPILER_LAUNCHER = "sccache";
    CMAKE_C_COMPILER_LAUNCHER = "ccache";
    CMAKE_C_COMPILER_LAUNCHER = "sccache";
    CUDAARCHS = "86";
    GTK_ENABLE_PRIMARY_PASTE = "1";
    LIBGL_ALWAYS_INDIRECT = "1";
    RUSTC_WRAPPER = "sccache";
    SCCACHE_CACHE_SIZE = "100G"
    SCCACHE_DIR "/store/sccache";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    TORCH_CUDA_ARCH_LIST = "8.6";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
