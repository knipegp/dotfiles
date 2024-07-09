{ config, pkgs, ... }:

{
  # Needs to be installed system-wide for some reason
  programs.steam.enable = true;
  # Used by udiskie for automounting
  services.udisks2.enable = true;

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "hyprland";
  };
}
