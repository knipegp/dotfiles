{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:

with lib;
let
  cfg = config.services.sunshine;
in
{
  options.services.sunshine = {
    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of users to add sunshine-required groups to (video, input)";
    };
  };

  config = {
    services.sunshine = {
      enable = true;
      package = pkgs-unstable.sunshine;
      capSysAdmin = true; # needed for wayland
      openFirewall = true;
    };

    networking = {
      firewall.allowedTCPPorts = [ 5201 ];
      firewall.allowedUDPPorts = [ 5201 ];
    };

    environment.systemPackages = with pkgs; [
      # Network characterization
      iperf3
    ];

    # Dynamically add required groups to specified users
    users.users = mkMerge (
      map (userName: {
        ${userName}.extraGroups = [
          "video"
          "input"
        ];
      }) cfg.users
    );
  };
}
