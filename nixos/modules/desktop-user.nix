{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs29-pgtk
    discord
    librewolf
    # Use firefox for persistently logged on accounts
    firefox
    kitty
    spotify
    signal-desktop
    parted

    # Photo editing
    darktable

    # Sway
    waybar
    font-awesome
    wpaperd
    brightnessctl

    # Hyprland
    mako
    wofi
    waybar
    killall
    wpaperd
    font-awesome
    hyprlock
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
  ];

  home.file = {
    "${config.xdg.configHome}/doom" = {
      source = ../files/doom;
      recursive = true;
    };
    # "${config.xdg.configHome}/sway" = {
    #   source = ../files/sway;
    #   recursive = true;
    #   onChange = "${pkgs.sway}/bin/swaymsg reload";
    # };
    "${config.xdg.configHome}/hypr" = {
      source = ../files/hyprland;
      recursive = true;
      onChange = "${pkgs.hyprland}/bin/hyprctl reload";
    };
    "${config.xdg.configHome}/waybar" = {
      source = ../files/waybar;
      recursive = true;
      onChange = "${pkgs.killall}/bin/killall -SIGUSR2 .waybar-wrapped";
    };
    "${config.xdg.configHome}/waybar/scripts" = {
      source = ../files/waybar/scripts;
      recursive = true;
    };
    # "${config.xdg.configHome}/alacritty/alacritty.toml" = {
    #   source = ../files/alacritty/alacritty.toml;
    # };
    "${config.xdg.configHome}/kitty/kitty.conf" = {
      source = ../files/kitty/kitty.conf;
    };
    "${config.xdg.configHome}/wpaperd/wallpaper.toml" = {
      source = ../files/wpaperd/wallpaper.toml;
    };
    # 1080p image. Should probably only use 4k
    "${config.xdg.configHome}/wallpaper/planets.jpeg" = {
      source = builtins.fetchurl {
        url = "https://i.imgur.com/7mtcJ3S.jpeg";
        sha256 = "148c766ygl7wsyi2nnv34y0bkz2w9c5x9d9w0a4xpcp7h835h7j0";
      };
    };
  };

}
