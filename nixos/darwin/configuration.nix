{ pkgs, ... }:

{
  # Nix configuration
  nix = {
    # Enable flakes and new nix command
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # macOS system preferences
  system = {
    # Set Git commit hash for darwin-hierarchical-version
    # configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility
    stateVersion = 6;

    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
      };

      # Global settings
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 14;
        KeyRepeat = 1;
        # Enable full keyboard access for all controls
        AppleKeyboardUIMode = 3;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
  };

  # System packages (available system-wide)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
  ];

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  programs.bash.enable = true;

  # Services
  services = {
    # Enable nix-daemon
    nix-daemon.enable = true;
  };
}
