# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./network.nix
    ./programs.nix
    ./security.nix
  ];

  nix.settings = {
    max-jobs = "auto";  # Uses all available CPU cores
    cores = 0;          # 0 means "use all cores" for individual build steps
    experimental-features = [ "nix-command" "flakes" ];
    use-sqlite-wal = true;
    auto-optimise-store = true;
  };

  nixpkgs.config = {
  # Allow unfree packages
    allowUnfree = true;
    allowParallelBuilding = true;
  };

  wsl.enable = true;
  wsl.defaultUser = "devmarx";
    # Graphics drivers
  virtualisation.docker = {
     enable = true;
     enableOnBoot = true;
  };
  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.devmarx = {};

  users.users.devmarx = {
    description = "/dev/marx";
    enable = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" "wireshark" ];
    group = "devmarx";
    home = "/home/devmarx";
    isSystemUser = true;
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
