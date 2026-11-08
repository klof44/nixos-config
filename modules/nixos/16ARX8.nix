# This file contains device-specific configs for the Lenovo Legion 16ARX8
{ config, pkgs, lib, ... }:
{
  services.xserver.dpi = 189;
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.extraModprobeConfig = ''
    # Fix for buzzing when aux is plugged directly into an amplifier
    options snd_hda_intel power_save=0

    # Fix for wifi not working after suspend
    options rtw89_pci disable_aspm_l1=Y disable_aspm_l1ss=Y
  '';

  # I almost never use hybrid mode but leaving the options on does not do any harm
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
