{
  environment,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs.cudaPackages; [
    cudatoolkit
    cudnn
  ];

  # For GUI apps using GPU (WSLg)
  environment.variables = {
    LIBGL_ALWAYS_INDIRECT = "1";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GTK_ENABLE_PRIMARY_PASTE = "1";
    # NVCC/CMake will honor these in many projects
    CUDAARCHS = "86";
    CMAKE_CUDA_ARCHITECTURES = "86";
    # PyTorch/XLA/etc.
    TORCH_CUDA_ARCH_LIST = "8.6";
  };
}
