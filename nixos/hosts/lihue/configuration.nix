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
      "admin"
    ];

    logind = {
      lidSwitch = "lock";  # Lock the screen instead of ignoring
      lidSwitchDocked = "lock";  # Lock when docked too
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=poweroff
        IdleAction=lock
        IdleActionSec=10min
      '';
    };

    # Configure auto-login for duloc
    displayManager.autoLogin = {
      enable = true;
      user = "duloc";
    };
  };

  # Disable GNOME autosuspend since we're handling it at the system level
  services.xserver.displayManager.gdm.autoSuspend = false;

  # Configure GDM to allow empty passwords for duloc
  security.pam.services.gdm.text = ''
    # Account management.
    account required pam_unix.so

    # Authentication management.
    auth     sufficient pam_unix.so likeauth nullok
    auth     optional pam_gnome_keyring.so

    # Password management.
    password sufficient pam_unix.so nullok

    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
    session optional pam_gnome_keyring.so auto_start
  '';

  # System-wide power management settings
  powerManagement = {
    enable = true;
    powertop.enable = true;  # Enable powertop for additional power savings
    cpuFreqGovernor = "schedutil";  # Use schedutil for best performance/power balance
  };
  
  # Enable balanced power saving for WiFi (rather than aggressive)
  networking.networkmanager.wifi.powersave = true;
  
  # Enable power management for PCIe devices
  powerManagement.powerUpCommands = ''
    ${pkgs.pciutils}/bin/setpci -v -H1 -s 0:1f.0 0xa4.b=0
  '';

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
    griff = {
      packages = with pkgs; [
        zellij
        bottom
      ];
    };
    duloc = {
      isNormalUser = true;
      # Set an initial empty password to allow passwordless login
      initialPassword = "";
      packages = with pkgs; [
        jellyfin-media-player
        pkgs-unstable.firefox
        pkgs-unstable.moonlight-qt
      ];
      # Explicitly disable SSH for duloc
      openssh.authorizedKeys.keys = [ ];
    };
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable sudo
      # No password - will authenticate via SSH keys only
      hashedPassword = "";
    };
  };
  security = {
    sudo.extraRules = [
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
  };
}
