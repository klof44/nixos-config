{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    inputs.silentSDDM.nixosModules.default
  ];

  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      wayland.enable = lib.mkForce true;
      wayland.compositorCommand = "${lib.getExe' pkgs.kdePackages.kwin "kwin_wayland"} --drm --no-lockscreen --no-global-shortcuts --locale1";
      enableHidpi = true;
      extraPackages = [
        pkgs.kdePackages.qtsvg 
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtvirtualkeyboard
        pkgs.kdePackages.layer-shell-qt
      ];
    };
  };

  security.pam.services.sddm.enableKwallet = true;
  security.pam.services = { 
   login.kwallet = { 
     enable = true; 
     package = pkgs.kdePackages.kwallet-pam; 
    }; 
  };

  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds = {
      default = ../../modules/home-manager/niri/bg.png;
    };
    profileIcons = {
      maxim = ../../modules/home-manager/.face;
    };
    settings = {
      "LockScreen".background = "bg.png";
      "LoginScreen".background = "bg.png";
    };
  };
}