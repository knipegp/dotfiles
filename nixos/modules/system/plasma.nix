{ pkgs, ... }:

{
  # Enable KDE Plasma desktop environment
  services = {
    xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      desktopManager.plasma6.enable = true;

      # Disable DPMS (Display Power Management Signaling) at X server level
      # This prevents the screen from blanking/sleeping
      monitorSection = ''
        Option "DPMS" "false"
      '';

      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  # KDE-specific packages
  environment.systemPackages = with pkgs; [
    kdePackages.kinfocenter
    kdePackages.systemsettings
    kdePackages.plasma-systemmonitor
  ];

  # Audio configuration
  security.rtkit.enable = true;

  # Disable powerdevil (KDE's power management daemon)
  # This is the most effective way to prevent KDE from managing power/screen blanking
  systemd.user.services.plasma-powerdevil = {
    enable = false;
  };

  # Create system-wide plasma configuration
  # These get merged with user configs and set defaults
  environment.etc = {
    # Disable power management in KDE Plasma to prevent sleeping
    "xdg/powermanagementprofilesrc".text = ''
      [AC]
      icon=battery-charging

      [AC][DPMSControl]
      idleTime=0

      [AC][SuspendAndShutdown]
      AutoSuspendAction=0
      PowerButtonAction=16
      LidAction=0

      [Battery]
      icon=battery-060

      [Battery][DPMSControl]
      idleTime=0

      [Battery][SuspendAndShutdown]
      AutoSuspendAction=0
      PowerButtonAction=16
      LidAction=0

      [LowBattery]
      icon=battery-low

      [LowBattery][DPMSControl]
      idleTime=0

      [LowBattery][SuspendAndShutdown]
      AutoSuspendAction=0
      PowerButtonAction=16
      LidAction=0
    '';

    # Disable KDE screen locker
    "xdg/kscreenlockerrc".text = ''
      [Daemon]
      Autolock=false
      LockOnResume=false
      Timeout=0
    '';

    # Disable screen energy saving in KDE
    "xdg/kded5rc".text = ''
      [Module-powerdevil]
      autoload=false
    '';
  };

  # Additional startup commands to disable DPMS
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xorg.xset}/bin/xset -dpms
    ${pkgs.xorg.xset}/bin/xset s noblank
  '';
}
