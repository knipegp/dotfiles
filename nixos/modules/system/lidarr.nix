{
  config,
  lib,
  ...
}:

with lib;

{
  options.services.lidarr-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Lidarr virtual host";
    };
  };

  imports = [ ./nginx.nix ];
  config = {
    # Enable Lidarr service
    services.lidarr = {
      enable = true;
      openFirewall = false; # We'll proxy through nginx instead
    };

    # Enable nginx and configure reverse proxy
    services.nginx.virtualHosts."lidarr.${config.services.lidarr-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8686";
        proxyWebsockets = true;
      };
    };

  };
}
