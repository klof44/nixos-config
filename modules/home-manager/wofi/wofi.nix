{ config, pkgs, ... }:
{
  home.file = {
    ".config/wofi/config".source = ./config;
    ".config/wofi/style.css".source = ./style.css;
    ".config/wofi/cliphist-wofi-img.sh".source = ./cliphist-wofi-img.sh;
  };

  home.packages = with pkgs; [
    wofi
    cliphist
    imagemagick # for clipboard thumbs
  ];
}