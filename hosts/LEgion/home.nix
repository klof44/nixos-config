{ lib, config, pkgs, inputs, ... }:

{
  home.username = "maxim";
  home.homeDirectory = "/home/maxim";

  home.stateVersion = "25.11"; # You should not change this value.

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    vscode
    nerd-fonts.jetbrains-mono
    vesktop
    arrpc
    spotify
    prismlauncher
    osu-lazer-bin
    jetbrains-toolbox
    inputs.DuckGameRebuilt.packages.x86_64-linux.default
    gitkraken
    onlyoffice-desktopeditors
    bun
    pinta
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../../modules/home-manager/niri/niri.nix
  ];
  
  home.file = {

  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
}
