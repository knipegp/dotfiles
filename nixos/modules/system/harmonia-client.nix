{
  nix.settings = {
    substituters = [
      "http://harmonia.haleakala"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "harmonia.haleakala:M2Pu6jHMged1HY4k0MQAJdTMoGBJRXYHZd6h+5NfiQM="
    ];
  };
}
