# Do not modify this file!
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =[ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    resumeDevice = "/dev/disk/by-uuid/9c7507ff-3aec-423a-b7a1-27fa91875b7f";
  };
  swapDevices = [{
    device = "/dev/disk/by-uuid/9c7507ff-3aec-423a-b7a1-27fa91875b7f";
  }];

  fileSystems = {

    "/" = {
      device = "/dev/disk/by-uuid/4e171dc0-a082-4e82-b611-c81a72c5b2d8";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/4e171dc0-a082-4e82-b611-c81a72c5b2d8";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    "/boot" = { 
      device = "/dev/disk/by-uuid/7C30-E3E2";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/blue" = {
      device = "/dev/disk/by-label/blue";
      fsType = "btrfs";
      options = [ "nofail" ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
