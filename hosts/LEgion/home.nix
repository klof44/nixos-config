{ lib, config, pkgs, inputs, ... }:

{
  home.username = "maxim";
  home.homeDirectory = "/home/maxim";

  home.stateVersion = "25.11"; # You should not change this value.

  home.packages = with pkgs; [
    vscode
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    vesktop
    spotify
    prismlauncher
    jetbrains-toolbox
    inputs.DuckGameRebuilt.packages.x86_64-linux.default
    gitkraken
    onlyoffice-desktopeditors
    bun
    signal-desktop
    davinci-resolve
    audacity
    deadlock-mod-manager

    teams-for-linux
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../../modules/home-manager/niri/niri.nix
    ../../modules/home-manager/sunshine/apps-fix.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
}
