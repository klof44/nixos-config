{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.file = {
    ".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "/home/maxim/.cache/noctalia/bg.png";
      };
    };
    ".cache/noctalia/bg.png".source = ./bg.png;
  };

  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        density = "compact";
        position = "top";
        showCapsule = false;
	transparentBackground = false;
        monitors = [ "eDP-1" ];

        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
              enableColorization = true;
              colorizeDistroLogo = true;
              colorizeSystemIcon = "primary";
            }
            { id = "Clock"; }
            { id = "ActiveWindow"; }
            { 
              id = "MediaMini";
              showAlbumArt = true;
              showVisualizer = false;
            }
          ];

          center = [
            { id = "Workspace"; }
          ];

          right = [
            { 
              id = "Tray"; 
              colorizeIcons = true;
              drawerEnabled = false;
            }
	    { id = "Network"; }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "NotificationHistory"; }
            { id = "Battery"; }
          ];
	      };
      };

      wallpaper = {
        enabled = true;
        directory = "/home/maxim/.cache/noctalia";
        overviewEnabled = true;
      };

      colorSchemes = {
        useWallpaperColors = true;
      };

      ui = {
        fontDefault = "Jetbrains Mono Nerd";
      };

      templates = {
        gtk = true;
        qt = true;
        foot = true;
      };

      location = { weatherEnabled = false; };

      network.wifiEnabled = true;

      dock = {
        enabled = false;
      };

      OSD = {
        monitors = [ "eDP-1" ];
      };
    };
  };
}
