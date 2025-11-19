{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs
    kitty
    clang # needed to build and install some emacs packages
  ];

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
