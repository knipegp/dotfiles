# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/system/desktop.nix
    ../../modules/system/hyprland.nix
    ../../modules/system/development.nix
    ../../modules/system/personal-user.nix
    # ../../modules/system/khoj.nix
    ../../modules/system/collect-garbage.nix
    ../../modules/system/immich.nix
    ../../modules/system/1password.nix
    ../../modules/system/syncthing.nix
    ../../modules/system/disk-management.nix
    ../../modules/system/ssh-server.nix
    ../../modules/system/lidarr.nix
    ../../modules/system/radarr.nix
    ../../modules/system/sonarr.nix
    ../../modules/system/jellyfin.nix
    ../../modules/system/navidrome.nix
    ../../modules/system/sunshine.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "haleakala"; # Define your hostname.
    networkmanager.enable = true;
  };
  services = {
    sshServer.user = "griff";
    # Configure Lidarr, Radarr, and Sonarr with hostname
    lidarr-custom = {
      hostname = "haleakala";
    };
    radarr-custom = {
      hostname = "haleakala";
    };
    sonarr-custom = {
      hostname = "haleakala";
    };
    jellyfin-custom = {
      hostname = "haleakala";
    };
    immich-custom = {
      hostname = "haleakala";
    };
    # khoj-custom = {
    #   hostname = "haleakala";
    # };
    navidrome-custom = {
      hostname = "haleakala";
    };
  };
  nix.settings.trusted-users = [
    "root"
    "griff"
  ];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
