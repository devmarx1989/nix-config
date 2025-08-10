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
      cudaSupport = false;
    };
  };
}
