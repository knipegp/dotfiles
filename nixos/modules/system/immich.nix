{ ... }:

{
  services.immich.accelerationDevices = null;
  hardware.graphics.enable = true;
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };
  users.users.immich.extraGroups = [ "video" "render" ];
}
