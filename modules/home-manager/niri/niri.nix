{ pkgs, inputs, ... }:
{
  home.file = {
    ".config/niri/config.kdl".source = ./config.kdl;
    ".config/hypr/bg.png".source = ./bg.png;
  };

  home.packages = with pkgs; [
    niri
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
    ../hyprlock/hyprlock.nix
  ];
}
