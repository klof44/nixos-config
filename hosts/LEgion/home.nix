{ lib, config, pkgs, inputs, ... }:

{
  home.username = "maxim";
  home.homeDirectory = "/home/maxim";

  home.packages = with pkgs; [
    vscode
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    vesktop
    prismlauncher
    jetbrains-toolbox
    inputs.DuckGameRebuilt.packages.x86_64-linux.default
    euro-office-desktopeditors
    signal-desktop
    davinci-resolve
    audacity
    teams-for-linux
    lutris
    feishin
    moonlight-qt
    cloudflared
    remmina
    protonplus
    libxcursor
    flatpak
    scrcpy
    v4l-utils
    ffmpeg-full
    powertop
    networkmanagerapplet
    fishPlugins.hydro
    fishPlugins.z
    fishPlugins.done
    jq
    vscode
    nodejs
    bun
    picard
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../../modules/home-manager/niri/niri.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  home.stateVersion = "25.11"; # You should not change this value.
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
}
