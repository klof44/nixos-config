{ config, pkgs, inputs, lib, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ../../modules/nixos/16ARX8.nix
      ../../modules/nixos/sunshine.nix
      inputs.silentSDDM.nixosModules.default
  ];

  swapDevices = [{
    device = "/dev/disk/by-uuid/9c7507ff-3aec-423a-b7a1-27fa91875b7f";
  }];
  boot.resumeDevice = "/dev/disk/by-uuid/9c7507ff-3aec-423a-b7a1-27fa91875b7f";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 12;

  boot.kernelModules  = [ "v4l2loopback" ];

  boot.kernel.sysctl."vm.max_map_count" = 2147483642;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  boot.extraModprobeConfig = ''
  options snd_hda_intel power_save=0
  options rtw89_pci disable_aspm_l1=Y disable_aspm_l1ss=Y
  '';
  services.udev.extraRules = ''
  ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x15b8" ATTR{power/wakeup}="disabled"
  ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x15b7" ATTR{power/wakeup}="disabled"

  # Keyboard and Touchpad no suspend
  # ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c103", TEST=="power/control", ATTR{power/control}="on"
  # ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c985", TEST=="power/control", ATTR{power/control}="on"
  '';

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-uuid/dc969b4e-69f4-4046-9c20-dcd72a0eaedf";
    fsType = "btrfs";
  };
  fileSystems."/mnt/blue" = {
    device = "/dev/disk/by-uuid/92a5964d-d0fc-4adc-b929-3b5a19c5b14d";
    fsType = "btrfs";
  };
  fileSystems."/mnt/win" = {
    device = "/dev/disk/by-uuid/DAAAEB5AAAEB31A5";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "users"
      "nofail"
      "exec"
    ];
  };

  networking.hostName = "LEgion"; # Define your hostname.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.enableRedistributableFirmware = true;
  networking.networkmanager.wifi.powersave = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d --delete-generations +3";
  };
  nix.settings.auto-optimise-store = true;

  programs.localsend.enable = true;

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Winnipeg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  programs.niri.enable = true;

  services.xserver.enable = true;
  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      wayland.enable = lib.mkForce true;
      enableHidpi = true;
      extraPackages = [
        pkgs.kdePackages.qtsvg 
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtvirtualkeyboard
      ];
    };
  };
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds = {
      default = ../../modules/home-manager/niri/bg.png;
    };
    profileIcons = {
      maxim = ../../modules/home-manager/noctalia/.face;
    };
    settings = {
      "LockScreen".background = "bg.png";
      "LoginScreen".background = "bg.png";
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # powerManagement.powertop.enable = true;

  services.system76-scheduler.settings.cfsProfiles.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 81;
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
    };
  };
  services.upower = {
    enable = true;
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.obs-studio = {
    enable = true;
    package = (pkgs.obs-studio.override {
      cudaSupport = true;
    });

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-gstreamer
    ];

    enableVirtualCamera = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override
    {
      extraPkgs = pkgs: 
      [
        pkgs.icu
        pkgs.libxcrypt-legacy
        pkgs.python312
        pkgs.python312Packages.torch
      ]; 
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      alias nrs="sudo nixos-rebuild switch --flake /home/maxim/config/#LEgion"
      alias nrsu="sudo nix flake update --flake /home/maxim/config && sudo nixos-rebuild switch --flake /home/maxim/config/#LEgion --upgrade"
      function ns
        export NIXPKGS_ALLOW_UNFREE=1
      	nix-shell -p $argv
        fish
      end
    '';
  };

  programs.gamemode.enable = true;

  users.users.maxim = {
    isNormalUser = true;
    description = "Maxim";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      protonplus
      libxcursor
      flatpak
      scrcpy
      v4l-utils
      ffmpeg-full
      powertop
      direnv
      networkmanagerapplet

      fishPlugins.hydro
      fishPlugins.z
      fishPlugins.done
      jq
    ];
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ "root" "maxim" ];

  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  home-manager = {
    users = {
      "maxim" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  fonts.fontDir.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim 
    git
    gparted
    btop
    firefox
    mpv
    nvtopPackages.nvidia
    nvtopPackages.amd
    nautilus
    polkit_gnome
    gpu-screen-recorder-gtk
    dnsmasq
    wl-clipboard
    foot
    pavucontrol
    gamescope-wsi

    mono
  ];
  programs.gpu-screen-recorder.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  boot.kernelParams = [ "transparent_hugepage=never" /* "clocksource=tsc" "tsc=reliable" BETTER GAME LOAD TIMES BUT BREAKS VMWARE */ ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
