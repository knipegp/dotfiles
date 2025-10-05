{ config, lib, ... }:

with lib;

{
  options.services.navidrome-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Navidrome virtual host";
    };
  };

  imports = [ ./nginx.nix ];
  config = {
    services.navidrome = {
      enable = true;
      settings.MusicFolder = "/mnt/data1/music";
    };

    services.nginx.virtualHosts."navidrome.${config.services.navidrome-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:4533";
        proxyWebsockets = true;
      };
    };

  };
}
