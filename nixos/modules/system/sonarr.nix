{ config, lib, ... }:

with lib;

{
  options.services.sonarr-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Sonarr virtual host";
    };
  };

  imports = [ ./nginx.nix ];
  config = {
    # Enable Sonarr service
    services.sonarr = {
      enable = true;
      openFirewall = false; # We'll proxy through nginx instead
    };

    # Enable nginx and configure reverse proxy
    services.nginx.virtualHosts."sonarr.${config.services.sonarr-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
        proxyWebsockets = true;
      };
    };

  };
}
