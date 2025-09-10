{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python313
    uv
    ruff
    pyright
  ];

  # Needed for jupyter notebook
  home.sessionVariables = rec {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
