{ ... }:

{
  # Needs to be installed system-wide for some reason
  programs.steam.enable = true;

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "hyprland";
  };
}
