{ users, pkgs, ... }:
let
 user = "dev-marx";
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.${user} = {};
  
  users.users.devmarx = {
    description = "/dev/marx";
    enable = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" "wireshark" ];
    group = user;
    home = "/home/dev-marx";
    isNormalUser = true;
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}
