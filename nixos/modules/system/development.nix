{ options, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default;
  environment.sessionVariables.SSH_AUTH_SOCK = "";
}
