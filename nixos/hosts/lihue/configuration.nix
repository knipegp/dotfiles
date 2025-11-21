{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/desktop.nix
    ../../modules/system/gnome.nix
    ../../modules/system/griff-user.nix
    ../../modules/system/collect-garbage.nix
    ../../modules/system/1password.nix
    ../../modules/system/syncthing.nix
    ../../modules/system/disk-management.nix
    ../../modules/system/harmonia-client.nix
    ../../modules/system/ssh-server.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "lihue"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };
  };

  services = {
    sshServer.users = [
      "griff"
      "ripper"
      "admin"
    ];

    # Disable sleep and suspend for server operation
    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = ''
        HandlePowerKey=ignore
        IdleAction=ignore
      '';
    };

    # Configure auto-login for duloc
    displayManager.autoLogin = {
      enable = true;
      user = "duloc";
    };
  };

  # Prevent GNOME from suspending
  systemd = {
    services."getty@tty1".enable = false;
    services."autovt@tty1".enable = false;
    # Additional systemd sleep settings
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowSuspendThenHibernate=no
      AllowHybridSleep=no
    '';
  };

  # Disable automatic suspend in GNOME
  services.xserver.displayManager.gdm.autoSuspend = false;

  # System-wide power management settings
  powerManagement = {
    enable = true;
    powertop.enable = false;
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "griff"
      "admin"
    ];
  };

  users.users = {
    duloc = {
      isNormalUser = true;
      # No password - empty password hash
      hashedPassword = "";
      packages = with pkgs; [
        jellyfin-media-player
        pkgs-unstable.firefox
      ];
      # Explicitly disable SSH for duloc
      openssh.authorizedKeys.keys = [ ];
    };
    ripper = {
      isNormalUser = true;
      packages = with pkgs; [
        ffmpeg
      ];
    };
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable sudo
      # No password - will authenticate via SSH keys only
      hashedPassword = "";
    };
  };
  security.sudo.extraRules = [
    {
      users = [ "admin" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
