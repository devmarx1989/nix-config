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
      ccache.enable = true;
    };
    config.permittedInsecurePackages = [
      "squid-7.0.1"
    ];
  };
}
