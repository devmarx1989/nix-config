{ security }:
{
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel"]; noPass = true; keepEnv = true; }
    ];
  };
  security.rtkit.enable = true;
}
