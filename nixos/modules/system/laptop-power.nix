{ lib, config, ... }:

{
  options = {
    laptopPower = {
      resumeDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to the swap device for hibernation resume";
        example = "/dev/disk/by-uuid/762e6538-bd80-4d17-ac50-7d0ad80cf419";
      };
    };
  };

  config = {
    # Power management for laptops
    powerManagement = {
      enable = true;
      # Hibernate on critical battery level
      cpuFreqGovernor = "ondemand";
    };

    # Suspend-then-hibernate: suspend for 30 minutes, then hibernate
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=30m
      SuspendState=mem
    '';

    # Enable hibernation support
    boot.resumeDevice = lib.mkIf (
      config.laptopPower.resumeDevice != null
    ) config.laptopPower.resumeDevice;

    services = {
      # Automatic suspend on low battery
      upower = {
        enable = true;
        percentageLow = 20;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 60;

          # Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

          # Disable wake on LAN
          WOL_DISABLE = "Y";

          # Aggressive suspend settings
          SOUND_POWER_SAVE_ON_AC = 0;
          SOUND_POWER_SAVE_ON_BAT = 1;
          SOUND_POWER_SAVE_CONTROLLER = "Y";

          # SATA link power management
          SATA_LINKPWR_ON_AC = "med_power_with_dipm";
          SATA_LINKPWR_ON_BAT = "min_power";
        };
      };

      # Logind settings for better suspend behavior
      logind = {
        lidSwitch = "suspend-then-hibernate";
        lidSwitchExternalPower = "suspend";
        powerKey = "suspend-then-hibernate";
        extraConfig = ''
          HandleSuspendKey=suspend-then-hibernate
          IdleAction=suspend-then-hibernate
          IdleActionSec=20m
        '';
      };
    };

    # NetworkManager configuration to prevent wifi radio from disabling on resume
    networking.networkmanager.settings = {
      wifi = {
        powersave = "off";
      };
    };
  };
}
