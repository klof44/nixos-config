{ config, pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    extraDaemonFlags = ["--no-logs-no-support"];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      key_rightalt_to_key_win = true;
      upnp = true;
      origin_web_ui_allowed = "pc";
      back_button_timeout = 300;
      output_name = 1;
    };

/* Broken on latest, see ../home-manager/sinshine/apps-fix.nix
    applications = {
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
            "gamemoderun gamescope -f -W 1920 -H 1080 -e --rt -r 165 --hdr-enable --hdr-itm-enable --adaptive-sync --force-grab-cursor -- steam -steamos3 -steampal -steamdeck -gamepadui"
          ];
        }
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
      ];
    };
*/
  };
}
