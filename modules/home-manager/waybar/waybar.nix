{ config, pkgs, ... }:
{
  home.file = {
    ".config/waybar".source = ./waybar;
  };

  home.packages = with pkgs; [
    waybar
    playerctl
  ];
}