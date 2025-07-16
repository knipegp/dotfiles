{ lib, config, ... }:

{
  imports = [ ../../modules/system/1password.nix ];

  options = {
    services.onepassword = {
      polkitPolicyOwners = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description =
          "List of users that should be part of the polkitPolicyOwners for 1Password GUI";
      };
    };
  };

  config = {
    programs = {
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        inherit (config.services.onepassword) polkitPolicyOwners;
      };
    };
  };

}
