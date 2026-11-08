{ config, pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];
  nix.settings = {
    extra-substituters = [ "https://cache.forall.systems" ]; # affinity
    extra-trusted-public-keys = [ "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI=" ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim 
    git
    gh
    cifs-utils
    gparted
    btop
    firefox
    mpv
    nvtopPackages.nvidia
    nvtopPackages.amd
    polkit_gnome
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

    affinity-v3
    (import inputs.creamlinux-installer { inherit pkgs; })
  ];

  programs.niri.enable = true;

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
  fonts.fontDir.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  programs.virt-manager.enable = true;

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

  programs.gamemode.enable = true;

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}