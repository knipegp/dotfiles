{ ... }:

{
  # Home Manager configuration for macOS
  home = {
    username = "griff";
    homeDirectory = "/Users/griff";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    stateVersion = "23.11";

    sessionVariables = {
      # macOS-specific environment variables can go here
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
