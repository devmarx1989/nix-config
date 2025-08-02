{ environment, ... }:
{
  environment.systemPackages = with pkgs; [
    nvidia-cuda-toolkit     # for nvcc and CUDA SDK
    nvidia-vaapi-driver     # optional: for hardware video decoding
    glxinfo                 # to test OpenGL
    vulkan-tools            # to test Vulkan support
  ];

  # For GUI apps using GPU (WSLg)
  environment.variables = {
    LIBGL_ALWAYS_INDIRECT = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

}
