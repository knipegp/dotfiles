{ pkgs, lib, ... }:

{
  # Enable GNOME desktop environment
  services = {
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };
    # Enable GNOME keyring
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  # GNOME-specific packages
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    dconf-editor
  ];

  # Audio configuration (shared with Hyprland)
  security.rtkit.enable = true;

  # Disable power management in GNOME to prevent sleeping
  programs.dconf = {
    enable = true;
    profiles = {
      user = {
        databases = [
          {
            settings = {
              "org/gnome/settings-daemon/plugins/power" = {
                active = false;
                sleep-inactive-ac-type = "nothing";
                sleep-inactive-battery-type = "nothing";
                sleep-inactive-ac-timeout = lib.gvariant.mkUint32 0;
                sleep-inactive-battery-timeout = lib.gvariant.mkUint32 0;
              };
              "org/gnome/desktop/session" = {
                idle-delay = lib.gvariant.mkUint32 0;
              };
              "org/gnome/desktop/screensaver" = {
                idle-activation-enabled = false;
              };
            };
          }
        ];
      };
    };
  };
}
