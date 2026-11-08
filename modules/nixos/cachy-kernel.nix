{ config, pkgs, inputs, ... }:
{
  # boot.kernelPackages = pkgs.linuxPackages_latest; # Use in case of breakage

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ]; # pinned so it's available from binary cache

  nix.settings = {
    substituters = [ "https://cache.lantian.pub/lantian" ];
    trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
  };
}