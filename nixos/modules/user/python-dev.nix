{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.platform;
  isDarwin = cfg.isDarwin or false;
in
{
  options.platform = {
    isDarwin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this is a nix-darwin (macOS) system";
    };
  };

  config = {
    home.packages = with pkgs; [
      python313
      uv
      ruff
      pyright
    ];

    # Needed for jupyter notebook
    # Use DYLD_LIBRARY_PATH on macOS, LD_LIBRARY_PATH on Linux
    home.sessionVariables = lib.mkIf (!isDarwin) {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };
}
