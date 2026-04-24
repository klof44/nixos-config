{...}: {
  home.file = {
    ".config/sunshine/apps.json".text = builtins.toJSON {
      env = {
        path = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Steamdeck";
          image-path = "steam.png";
          prep-cmd = [
            {
              do = "setsid steam steam://exit";
              undo = "pkill -9 gamescope-wl"; # gamescope never exits properly
            }
            /*
            {
              do = "niri msg output DP-2 on";
              undo = "niri msg output DP-2 off";
            }
            {
              do = "niri msg output DP-1 off";
              undo = "niri msg output DP-1 on";
            }
            {
              do = "niri msg output eDP-1 off";
              undo = "niri msg output eDP-1 on";
            }
            {
              do = "niri msg output HDMI-A-1 off";
              undo = "niri msg output DP-2 on";
            }
            {
              do = "niri msg action focus-monitor DP-2";
              undo = "";
            }
            */
          ];
          detached = [
            "gamemoderun gamescope -f -W 1920 -H 1080 -e --rt -r 144 --hdr-enable --hdr-itm-enable --force-grab-cursor -- steam -steamos3 -steampal -steamdeck -gamepadui"
          ];
        }
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
      ];
    };
  };
}