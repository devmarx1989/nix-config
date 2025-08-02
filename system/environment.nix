{ environment, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cacert
    nvidia-vaapi-driver     # optional: for hardware video decoding
    glxinfo                 # to test OpenGL
    vulkan-tools            # to test Vulkan support
  ];

  # For GUI apps using GPU (WSLg)
  environment.variables = {
    LIBGL_ALWAYS_INDIRECT = "1";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

}
