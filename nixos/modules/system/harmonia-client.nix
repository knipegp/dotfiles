{
  nix.settings = {
    substituters = [
      "http://harmonia.haleakala"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "harmonia.haleakala:M2Pu6jHMged1HY4k0MQAJdTMoGBJRXYHZd6h+5NfiQM="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    # This will make Nix fall back to the next substituter if one fails
    fallback = true;
    # Configure connection timeout (in seconds)
    connect-timeout = 10;
  };
}
