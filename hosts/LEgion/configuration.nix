{ config, pkgs, inputs, lib, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ../../modules/nixos/16ARX8.nix
      inputs.silentSDDM.nixosModules.default
  ];

  swapDevices = [{
    device = "/dev/disk/by-uuid/9c7507ff-3aec-423a-b7a1-27fa91875b7f";
  }];
  boot.resumeDevice = "/dev/disk/by-uuid/9c7507ff-3aec-423a-b7a1-27fa91875b7f";

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 12;
    };

    timeout = 0;
    efi.canTouchEfiVariables = true;
  };


  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "kernel.unprivileged_userns_clone" = 1;
  };

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];
  boot.kernelModules  = [ "v4l2loopback" ];
  
  boot.extraModprobeConfig = ''
  options snd_hda_intel power_save=0

  options rtw89_pci disable_aspm_l1=Y disable_aspm_l1ss=Y

  options v4l2loopback devices=2 video_nr=10,11 card_label="Virt Cam, OBS Cam" exclusive_caps=1
  '';

  services.udev.extraRules = ''
  ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x15b8" ATTR{power/wakeup}="disabled"
  ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x15b7" ATTR{power/wakeup}="disabled"

  # Keyboard and Touchpad no suspend
  # ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c103", TEST=="power/control", ATTR{power/control}="on"
  # ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="c985", TEST=="power/control", ATTR{power/control}="on"
  
  '';

  fileSystems."/mnt/blue" = {
    device = "/dev/disk/by-label/blue";
    fsType = "btrfs";
    options = [ "nofail" ];
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

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  networking.networkmanager = {
    enable = true;
  };
  networking.firewall = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Winnipeg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  programs.niri.enable = true;
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
      maxim = ../../modules/home-manager/noctalia/.face;
    };
    settings = {
      "LockScreen".background = "bg.png";
      "LoginScreen".background = "bg.png";
    };
  };
  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ brlaser ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

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
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
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
      obs-backgroundremoval
      obs-vkcapture
    ];
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
      ]; 
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      alias nrs="sudo nixos-rebuild switch --flake /home/maxim/config/#LEgion"
      alias nrsu="sudo nix flake update --flake /home/maxim/config && sudo nixos-rebuild switch --flake /home/maxim/config/#LEgion"
      function ns
        export NIXPKGS_ALLOW_UNFREE=1
      	nix shell nixpkgs#$argv
      end
    '';
  };

  programs.gamemode.enable = true;

  users.users.maxim = {
    isNormalUser = true;
    description = "Maxim";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ "root" "maxim" ];

  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

    package = pkgs.steam.override {
      extraEnv = {
        LD_AUDIT = "${
          inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/library-inject.so:${
          inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
        }/SLSsteam.so";
      };
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  home-manager = {
    users = {
      "maxim" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;

  services.tailscale = {
    enable = true;
    extraDaemonFlags = ["--no-logs-no-support"];
    port = 41642;
  };

  fonts.fontDir.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim 
    git
    gh
    gparted
    btop
    firefox
    mpv
    nvtopPackages.nvidia
    nvtopPackages.amd
    polkit_gnome
    gpu-screen-recorder-gtk
    dnsmasq
    wl-clipboard
    foot
    pavucontrol
    gamescope-wsi
    papirus-icon-theme
    virtiofsd
    mono
    unrar
    p7zip
    gtk3

    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.kwallet
  ];
  # virtualisation.vmware.host.enable = true; 
  
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
