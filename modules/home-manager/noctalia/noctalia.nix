{ pkgs, inputs, ... }:
{
  # No longer is use
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
    ".face".source = ./.face;
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
        fontDefault = "JetBrainsMono NF";
        fontFixed = "JetBrainsMono NF";
      };

      templates = {
        gtk = true;
        qt = true;
      };

      location = { weatherEnabled = false; };

      network.wifiEnabled = true;

      dock = {
        enabled = false;
      };

      OSD = {
        monitors = [ "eDP-1" ];
      };

    desktopWidgets = {
      enabled = true;
      gridSnap = true;
      monitorWidgets = [
        {
          name = "eDP-1";
          widgets = [
            {
              diskPath = "/";
              id = "SystemStat";
              layout = "bottom";
              roundedCorners = true;
              showBackground = true;
              statType = "CPU";
              x = 2304;
              y = 64;
            }
            {
              diskPath = "/";
              id = "SystemStat";
              layout = "bottom";
              roundedCorners = true;
              scale = 1;
              showBackground = true;
              statType = "Network";
              x = 2304;
              y = 320;
            }
            {
              diskPath = "/";
              id = "SystemStat";
              layout = "bottom";
              roundedCorners = true;
              showBackground = true;
              statType = "Memory";
              x = 2304;
              y = 192;
            }
          ];
        }
      ];
    };
    };
  };
}
