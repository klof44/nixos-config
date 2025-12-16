# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  swapDevices = [ {
    device = "/var/lib/swap";
    size = 32*1024;
  } ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModprobeConfig = ''
  options snd_hda_intel power_save=0
  '';

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-uuid/dc969b4e-69f4-4046-9c20-dcd72a0eaedf";
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Winnipeg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  programs.niri.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    # extraConfig.pipewire."92-low-latency" = {
    #  "context.properties" = {
    #     "default.clock.rate" = 48000;
    #     "default.clock.quantum" = 32;
    #     "default.clock.min-quantum" = 32;
    #     "default.clock.max-quantum" = 32;
    #   };
    # };
  };

  services = {
    upower.enable = true;

    tlp = {
      enable = true;
      settings = {
        USB_AUTOSUSPEND = 0;
	      RUNTIME_PM_ON_BAT = "on";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        STOP_CHARGE_THRESH_BAT0 = 95;
      };
    };
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.maxim = {
    isNormalUser = true;
    description = "Maxim";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      neovim
      git
      gamescope-wsi
      protonup-qt
      xorg.libXcursor
      flatpak
      scrcpy
      p7zip
    ];
    shell = pkgs.fish;
  };
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
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  home-manager = {
    users = {
      "maxim" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  programs.firefox.enable = true;

  fonts.fontDir.enable = true;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim 
    git
    gparted
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
