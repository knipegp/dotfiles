{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # CD ripping
    abcde
    flac
    cdparanoia

    # DVD/Blu-ray ripping
    makemkv
    ffmpeg
  ];

  home.file = {
    "${config.home.homeDirectory}/.abcde.conf" = {
      source = ../../files/abcde.conf;
    };
  };
}
