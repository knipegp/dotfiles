{ pkgs, ... }:

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
}
