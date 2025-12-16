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
	monitors = [ "eDP-1" ];

	widgets = {
	  left = [
	    { id = "Clock"; }
	    { id = "ActiveWindow"; }
	    { id = "MediaMini"; }
	  ];

	  center = [
	    { id = "Workspace"; }
	  ];

	  right = [
	    { id = "Tray"; }
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

      colourSchemes = {
        useWallpaperColors = true;
        matugenSchemeType = "fidelity";
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
    };
  };
}
