{ hardware, ...}:
{
  hardware.nvidia = {
    enabled = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = true;
  };
  
  hardware.nvidia-container-toolkit.enable = true;
}
