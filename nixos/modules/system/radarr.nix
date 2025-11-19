{ config, lib, ... }:

with lib;

{
  options.services.radarr-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Radarr virtual host";
    };
  };

  imports = [ ./nginx.nix ];
  config = {
    # Enable Radarr service
    services.radarr = {
      enable = true;
      openFirewall = false; # We'll proxy through nginx instead
    };

    # Enable nginx and configure reverse proxy
    services.nginx.virtualHosts."radarr.${config.services.radarr-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
        proxyWebsockets = true;
      };
    };

  };
}
