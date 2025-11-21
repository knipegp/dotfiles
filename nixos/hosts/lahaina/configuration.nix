{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/desktop.nix
    ../../modules/system/hyprland.nix
    ../../modules/system/development.nix
    ../../modules/system/griff-user.nix
    ../../modules/system/collect-garbage.nix
    ../../modules/system/1password.nix
    ../../modules/system/syncthing.nix
    ../../modules/system/laptop-power.nix
    ../../modules/system/printing.nix
    ../../modules/system/disk-management.nix
    ../../modules/system/harmonia-client.nix
    ../../modules/system/ssh-server.nix
  ];

  # Laptop power management configuration
  laptopPower = {
    resumeDevice = "/dev/disk/by-uuid/762e6538-bd80-4d17-ac50-7d0ad80cf419";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "lahaina"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
  };

  services = {
    sshServer.users = [
      "griff"
      "ripper"
    ];
  };

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # User configuration for ripper - video encoding/transcoding user
  users.users.ripper = {
    isNormalUser = true;
    extraGroups = [
      "video"
      "render"
    ]; # GPU access for hardware encoding
    packages = with pkgs; [
      pkgs-unstable.ffmpeg-full # Full ffmpeg with all codec and hardware acceleration support
      libva-utils # Utilities to check VAAPI setup (vainfo command)
      intel-gpu-tools # Intel GPU monitoring and debugging tools
    ];
  };

  # Allow intel_gpu_top to access performance monitoring
  security.wrappers.intel_gpu_top = {
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon=ep";
    source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
  };
}
