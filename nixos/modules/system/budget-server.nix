{ config, lib, ... }:

with lib;
{
  options.services.budget-server-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Budget Server virtual host";
    };
  };

  imports = [ ./nginx.nix ];

  config = {
    # Enable the budget-server service
    services.actual = {
      enable = true;
    };

    # Enable nginx and configure reverse proxy
    services.nginx.virtualHosts."actual.${config.services.budget-server-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
  };
}
