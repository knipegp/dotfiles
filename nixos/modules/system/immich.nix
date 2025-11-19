{ config, lib, ... }:

with lib;
{
  options.services.immich-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Immich virtual host";
    };
  };
  imports = [ ./nginx.nix ];
  config = {
    hardware.graphics.enable = true;
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      openFirewall = false;
      mediaLocation = "/mnt/data1/immich";
      accelerationDevices = null;
    };
    users.users.immich.extraGroups = [
      "video"
      "render"
    ];

    services.nginx.virtualHosts."immich.${config.services.immich-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:2283";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };
  };
}
