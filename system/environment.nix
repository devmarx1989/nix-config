{
  environment,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs.cudaPackages; [
    #cudatoolkit
    #cudnn
  ];

  # For GUI apps using GPU (WSLg)
  environment.variables = {
    LIBGL_ALWAYS_INDIRECT = "1";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
