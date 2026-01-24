{ config
, pkgs
, pkgs-stable
, ...
}:
{
  home.packages = with pkgs; [
    discord
    # Needed for DRM websites (Netflix)
    signal-desktop
    parted

    libreoffice

    # Photo editing
    darktable

    # Shared Wayland tools (used by both Hyprland and Sway)
    mako
    brightnessctl
    waybar
    killall
    wpaperd
    font-awesome
    imagemagick # for compositor lock screen blur scripts
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout

    # User tools
    udiskie

    alsa-utils # Includes amixer for volume changing scripts

    pkgs-stable.protonvpn-gui

    # gaming
    moonlight-qt

    pkgs-stable.jellyfin-media-player
  ];

  programs = {
    # Note: librewolf requires compilation (no maintained binary package in nixpkgs)
    # First build takes ~1 hour, but subsequent builds use cache
    # Alternative: use firefox which has good binary cache support
    # librewolf.enable = true;
    firefox.enable = true;
    rofi = {
      enable = true;
      package = pkgs.rofi;
      plugins = [ pkgs.rofi-emoji ];
    };
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "always";
  };

  home.file = {
    # Shared wallpaper config
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
    "${config.home.homeDirectory}/.local/bin/screenshot" = {
      source = ../../files/scripts/screenshot.sh;
      executable = true;
    };
  };

}
