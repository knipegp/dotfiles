{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ emacs kitty ];

  home.file = {
    "${config.xdg.configHome}/doom" = {
      source = ../../files/doom;
      recursive = true;
    };
    "${config.xdg.configHome}/kitty/kitty.conf" = {
      source = ../../files/kitty/kitty.conf;
    };
  };
}
