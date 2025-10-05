{
  ...
}:

{
  # Enable nginx and configure reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

  };

  # Open firewall for nginx
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
