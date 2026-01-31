{ lib, config, pkgs, inputs, ... }:

{
  home.username = "maxim";
  home.homeDirectory = "/home/maxim";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inputs.DuckGameRebuilt.packages.x86_64-linux.default
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
