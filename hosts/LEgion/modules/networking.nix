{ config, pkgs, ... }:
{
  networking.hostName = "LEgion";

  networking.networkmanager.wifi.powersave = false;

  fileSystems."/mnt/media" = {
    device = "//10.0.0.43/media";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smbcredentials" "nofail" "uid=1000" "gid=1000"];
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ brlaser ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.tailscale = {
    enable = true;
    extraDaemonFlags = ["--no-logs-no-support"];
    port = 41642;
  };

  networking.networkmanager = {
    enable = true;
  };
  networking.firewall = {
    enable = true;
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}