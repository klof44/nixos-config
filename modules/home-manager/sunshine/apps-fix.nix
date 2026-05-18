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