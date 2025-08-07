# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./fileSystems.nix
    ./fonts.nix
    ./environment.nix
    ./hardware.nix
    ./hardware-configuration.nix
    ./network.nix
    ./nixpkgs.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./systemd.nix
    ./time.nix
    ./users.nix
  ];

  nix.settings = {
    max-jobs = "auto";  # Uses all available CPU cores
    cores = 0;          # 0 means "use all cores" for individual build steps
    experimental-features = [ "nix-command" "flakes" ];
    use-sqlite-wal = true;
    trusted-users = [ "root" "dev-marx" ];
    auto-optimise-store = true;
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      # public key printed by `cachix use cuda-maintainers`
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  nixpkgs.config = {
  # Allow unfree packages
    allowUnfree = true;
    allowParallelBuilding = true;
  };

    # Graphics drivers
  virtualisation.docker = {
     enable = true;
     enableOnBoot = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
