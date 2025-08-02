{ users }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.devmarx = {};

  users.users.devmarx = {
    description = "/dev/marx";
    enable = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" "wireshark" ];
    group = "devmarx";
    home = "/home/devmarx";
    isNormalUser = true;
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}
