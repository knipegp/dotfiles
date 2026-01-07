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

  environment.etc = {
    # Disable power management in KDE Plasma to prevent sleeping
    # KDE uses powerdevil for power management
    "xdg/powermanagementprofilesrc".text = ''
      [AC][SuspendAndShutdown]
      AutoSuspendAction=0
      PowerButtonAction=16

      [AC][DPMSControl]
      idleTime=0

      [Battery][SuspendAndShutdown]
      AutoSuspendAction=0
      PowerButtonAction=16

      [Battery][DPMSControl]
      idleTime=0

      [LowBattery][SuspendAndShutdown]
      AutoSuspendAction=0
      PowerButtonAction=16

      [LowBattery][DPMSControl]
      idleTime=0
    '';
    # Disable KDE screen locker
    "xdg/kscreenlockerrc".text = ''
      [Daemon]
      Autolock=false
      LockOnResume=false
    '';
  };

}
