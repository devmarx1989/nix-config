{ users, pkgs, lib, ... }:
let
 user = "dev-marx";
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.${user} = {};
  
  users.users.${user} = {
    description = "/dev/marx";
    enable = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" "wireshark" "render" ];
    group = user;
    home = "/home/dev-marx";
    isNormalUser = true;
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}
