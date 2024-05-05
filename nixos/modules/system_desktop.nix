{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  services.udisks2.enable = true;
}
