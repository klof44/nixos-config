{ pkgs, inputs, ... }:
{
  home.file = {
    ".config/niri/config.kdl".source = ./config.kdl;
    ".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
    ".config/hypr/bg.png".source = ./bg.png;
  };

  home.packages = with pkgs; [
    niri
    hyprlock
    # hypridle
    xwayland-satellite
    brightnessctl
    swaybg
  ];

  imports = [
    ../wofi/wofi.nix
    ../dunst/dunst.nix
    ../foot/foot.nix
    ../waybar/waybar.nix
  ];
}
