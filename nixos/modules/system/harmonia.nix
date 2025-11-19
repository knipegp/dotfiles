{ config, lib, ... }:

with lib;

{
  options.services.harmonia-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Harmonia virtual host";
    };
  };

  imports = [ ./nginx.nix ];
  config = {
    # Enable Harmonia service
    services.harmonia = {
      enable = true;
      signKeyPath = "/var/lib/harmonia/secret-key";
    };

    # Enable nginx and configure reverse proxy
    services.nginx.virtualHosts."harmonia.${config.services.harmonia-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:5000";
        proxyWebsockets = true;
      };
    };

  };
}
