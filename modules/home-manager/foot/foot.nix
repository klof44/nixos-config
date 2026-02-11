{ config, pkgs, ... }:
{
  home.file = {
    ".config/foot/foot.ini".source = ./foot.ini;
  };
}