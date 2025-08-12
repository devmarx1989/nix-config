{
  nixpkgs,
  lib,
  ...
}: {
  # Allow unfree packages
  nixpkgs = {
    # Allow unfree packages
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      allowUnfree = true;
      allowParallelBuilding = true;
      cudaSupport = true;
      cudaCapabilities = ["8.6"];
      ccache = {
        enable = true;
        cacheSize = "200G";
      };
      ccacheStdenv = true;
    };
    config.permittedInsecurePackages = [
      "squid-7.0.1"
    ];
  };
}
