{
  config,
  pkgs,
  pkgs-stable,
  ...
}:
{
  programs.librewolf.enable = true;
  programs.firefox.enable = true;
  home.packages = with pkgs; [
    discord
    # Needed for DRM websites (Netflix)
    google-chrome
    spotify
    signal-desktop
    parted

    libreoffice

    # Photo editing
    pkgs-stable.darktable

    # Sway
    waybar
    font-awesome
    wpaperd
    brightnessctl

    # Hyprland
    mako
    brightnessctl
    wofi
    waybar
    killall
    wpaperd
    font-awesome
    hyprlock
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout

    # User tools
    udiskie

    alsa-utils # Includes amixer for volume changing scripts

    protonvpn-gui
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-emoji ];
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "always";
  };

  home.file = {
    # "${config.xdg.configHome}/sway" = {
    #   source = ../files/sway;
    #   recursive = true;
    #   onChange = "${pkgs.sway}/bin/swaymsg reload";
    # };
    "${config.xdg.configHome}/hypr" = {
      source = ../../files/hyprland;
      recursive = true;
      onChange = "${pkgs.hyprland}/bin/hyprctl reload";
    };
    "${config.xdg.configHome}/waybar" = {
      source = ../../files/waybar;
      recursive = true;
      onChange = "${pkgs.killall}/bin/killall -SIGUSR2 .waybar-wrapped";
    };
    "${config.xdg.configHome}/waybar/scripts" = {
      source = ../../files/waybar/scripts;
      recursive = true;
    };
    # "${config.xdg.configHome}/alacritty/alacritty.toml" = {
    #   source = ../files/alacritty/alacritty.toml;
    # };
    "${config.xdg.configHome}/wpaperd/wallpaper.toml" = {
      source = ../../files/wpaperd/wallpaper.toml;
    };
    # 1080p image. Should probably only use 4k
    "${config.xdg.configHome}/wallpaper/planets.jpeg" = {
      source = builtins.fetchurl {
        url = "https://i.imgur.com/7mtcJ3S.jpeg";
        sha256 = "148c766ygl7wsyi2nnv34y0bkz2w9c5x9d9w0a4xpcp7h835h7j0";
      };
    };
    "${config.home.homeDirectory}/.config/eww/include/saimoomedits/eww-widgets" = {
      source = builtins.fetchGit {
        url = "https://github.com/saimoomedits/eww-widgets.git";
        rev = "cfb2523a4e37ed2979e964998d9a4c37232b2975";
      };
    };
    "${config.home.homeDirectory}/.local/bin/screenshot" = {
      source = ../../files/scripts/screenshot.sh;
      executable = true;
    };
  };

}
