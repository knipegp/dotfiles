{ config
, pkgs
, pkgs-stable
, ...
}:
{
  home.packages = with pkgs; [
    wofi
    hypridle
    hyprlock
    imagemagick # for hyprlock.sh blur script
  ];

  home.file = {
    # Hyprland config files
    "${config.xdg.configHome}/hypr/hyprland.conf" = {
      source = ../../files/hyprland/hyprland.conf;
      onChange = "${pkgs-stable.hyprland}/bin/hyprctl reload";
    };
    "${config.xdg.configHome}/hypr/hyprlock.conf" = {
      source = ../../files/hyprland/hyprlock.conf;
    };
    "${config.xdg.configHome}/hypr/hypridle.conf" = {
      source = ../../files/hyprland/hypridle.conf;
    };
    "${config.xdg.configHome}/waybar" = {
      source = ../../files/waybar-hyprland;
      recursive = true;
      onChange = "${pkgs.killall}/bin/killall -SIGUSR2 .waybar-wrapped";
    };
  };
}
