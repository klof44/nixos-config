{ config, pkgs, lib, ... }:
{
  services.xserver.dpi = 189;

  boot.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  # boot.kernelParams = [ "amdgpu.ppfeaturemask=0xfff73fff" ];

  hardware = {
    graphics.enable = true;

    amdgpu.initrd.enable = false;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
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
