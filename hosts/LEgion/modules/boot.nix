{ config, ... }:
{
  boot.supportedFilesystems = [ "nfs" ];
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 12;
    };

    timeout = 1;
    efi.canTouchEfiVariables = true;
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642; # Deadlock
  };

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];
  boot.kernelModules  = [ "v4l2loopback" ];
  boot.kernelParams = [ "transparent_hugepage=never" /* "clocksource=tsc" "tsc=reliable" BETTER GAME LOAD TIMES BUT BREAKS VMWARE */ ];
  
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 video_nr=10,11 card_label="Virt Cam, OBS Cam" exclusive_caps=1
  ''; 
}