{ pkgs, inputs, ... }:
{
  home.file = {
    ".config/niri/config.kdl".source = ./config.kdl;
  };

  home.packages = with pkgs; [
    niri
    hyprlock
    hypridle
    xwayland-satellite
  ];

  imports = [
    ../noctalia/noctalia.nix
    ../wofi/wofi.nix
  ];
}
