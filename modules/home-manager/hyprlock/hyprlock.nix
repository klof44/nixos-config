{ pkgs, inputs, ... }:
{
  home.file = {
    ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
    ".config/hypr/scripts".source = ./scripts;
  };

  home.packages = with pkgs; [
    hyprlock
  ];
}
