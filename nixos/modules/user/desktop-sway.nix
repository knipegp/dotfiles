{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    bemenu
    imagemagick # for swaylock-blur.sh script
  ];

  home.file = {
    # Sway config files
    "${config.xdg.configHome}/sway/config" = {
      source = ../../files/sway/config;
      onChange = "${pkgs.sway}/bin/swaymsg reload";
    };
    "${config.xdg.configHome}/sway/config.d" = {
      source = ../../files/sway/config.d;
      recursive = true;
    };
    "${config.xdg.configHome}/waybar" = {
      source = ../../files/waybar-sway;
      recursive = true;
      onChange = "${pkgs.killall}/bin/killall -SIGUSR2 .waybar-wrapped";
    };
  };
}
