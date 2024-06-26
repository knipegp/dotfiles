{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  services.udisks2.enable = true;

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "hyprland";
  };
}
