{ ... }:

{
  networking = {
    firewall.allowedTCPPorts = [ 22000 ];
    firewall.allowedUDPPorts = [ 22000 21027 ];
  };
}
