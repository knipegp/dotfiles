{ config
, lib
, pkgs-unstable
, ...
}:

with lib;
{
  options.services.budget-server-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Budget Server virtual host";
    };
  };

  imports = [
    ./nginx.nix
    ./mkcert.nix
  ];

  config = {
    # Enable the budget-server service
    services = {
      actual = {
        enable = true;
        package = pkgs-unstable.actual-server;
      };
      mkcert.certs.actual = [
        "actual.${config.services.budget-server-custom.hostname}"
      ];
      # Enable nginx and configure reverse proxy
      nginx.virtualHosts."actual.${config.services.budget-server-custom.hostname}" = {
        onlySSL = true;
        sslCertificate = "/etc/mkcert/certs/actual/cert.pem";
        sslCertificateKey = "/etc/mkcert/certs/actual/key.pem";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
