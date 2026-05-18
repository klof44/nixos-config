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
      output_name = 2;
    };
  };
}
