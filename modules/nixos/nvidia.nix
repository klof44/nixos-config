# NVIDIA driver module

{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    # Experiment with power management to see if it works on your hardware
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Open fails to build, change later
    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
