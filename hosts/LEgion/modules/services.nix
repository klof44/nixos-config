{ config, ... }:
{
  security.polkit.enable = true;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;

    pulseaudio.enable = false;
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    system76-scheduler.settings.cfsProfiles.enable = true;
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 81;
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      };
    };
    upower = {
      enable = true;
    };

    flatpak.enable = true;

    gvfs.enable = true;
    tumbler.enable = true;
  };
}