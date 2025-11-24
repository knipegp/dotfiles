{
  pkgs,
  config,
  lib,
  ...
}:

with lib;

{
  options.services.jellyfin-custom = {
    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname for the Jellyfin virtual host";
    };
  };

  imports = [ ./nginx.nix ];
  config = {
    # Enable Jellyfin service
    services.jellyfin = {
      enable = true;
      openFirewall = false; # We'll proxy through nginx instead
    };

    # Enable nginx and configure reverse proxy
    services.nginx.virtualHosts."jellyfin.${config.services.jellyfin-custom.hostname}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
      };
    };
    users.users.jellyfin = {
      extraGroups = [
        "video"
        "render"
      ]; # GPU access for hardware encoding
      packages = with pkgs; [
        jellyfin-ffmpeg
      ];
    };

  };
}
