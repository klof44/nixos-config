{ config, pkgs, inputs, lib, ... }:
{
  # Remove when system no longer depends on GTK2 (When derivation warning goes away)
  nixpkgs.config.problems.handlers."gtk+".broken = "warn";

  imports = [
    # host-specific and personalized
    ./hardware-configuration.nix
    ./modules/networking.nix
    ./modules/boot.nix
    ./modules/programs.nix
    ./modules/services.nix

    # re-usable for other hosts/people
    ../../modules/nixos/16ARX8.nix
    ../../modules/nixos/SDDM.nix
    ../../modules/nixos/cachy-kernel.nix
  ];

  home-manager = {
    users = {
      "maxim" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d --delete-generations +3";
    };
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "America/Winnipeg";
  i18n.defaultLocale = "en_CA.UTF-8";

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gnome ];
    config.niri = {
      default = lib.mkForce [ "gnome" "kde"  ];
      "org.freedesktop.portal.FileChooser" = [ "kde" ];
      "org.freedesktop.portal.ScreenCast" = [ "gnome" ];
    };
  };

  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  users.users.maxim = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ "root" "maxim" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
