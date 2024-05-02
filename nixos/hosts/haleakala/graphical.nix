# Initially copied and adapted from https://nixos.wiki/wiki/Sway
{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  services.udisks2.enable = true;
}
