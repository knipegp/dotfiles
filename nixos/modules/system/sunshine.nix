{
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:

with lib;
{
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

}
