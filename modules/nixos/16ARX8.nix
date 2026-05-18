{ config, pkgs, lib, ... }:
{
  services.xserver.dpi = 189;

  services.xserver.videoDrivers = [ "nvidia" ];

  # boot.kernelParams = [ "amdgpu.ppfeaturemask=0xfff73fff" ];

  hardware = {
    graphics.enable = true;

    amdgpu.initrd.enable = false;

    nvidia = {
      open = true;

      modesetting.enable = true;
      nvidiaSettings = true;

      powerManagement.enable = true;
      powerManagement.finegrained = true;

      prime = {
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
  
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
}
