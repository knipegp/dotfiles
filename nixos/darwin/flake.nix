{
  description = "Nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin, # deadnix: skip
      home-manager,
      ...
    }:
    let
      # Configure for Apple Silicon by default
      # Change to "x86_64-darwin" for Intel Macs
      system = "aarch64-darwin";

      # User configuration
      username = "griff";
      hostname = "maui"; # Change this to your Mac's hostname
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          # Base nix-darwin configuration
          ./configuration.nix

          # Home Manager module for nix-darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} =
                { ... }:
                {
                  imports = [
                    ./home.nix
                    ../modules/user/development.nix
                    ../modules/user/desktop-development.nix
                    ../modules/user/gnupg.nix
                  ];

                  # Set platform flag for macOS
                  platform.isDarwin = true;
                };
            };

            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;

            # Set the username for nix-darwin
            users.users.${username} = {
              name = username;
              home = "/Users/${username}";
            };
          }
        ];
      };

      # Expose the package set for convenience
      darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
    };
}
