{
  description = "Home Manager configuration of griff";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-stable,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in
    {
      homeConfigurations."griff" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          ../modules/user/development.nix
          ../modules/user/desktop.nix
          { _module.args = { inherit pkgs-stable; }; }
          ../modules/user/personal.nix
          ../modules/user/desktop-development.nix
          ../modules/user/gnupg.nix
          ../modules/user/ssh-client.nix
          ../modules/user/media-ripping.nix
        ];

      };
    };
}
