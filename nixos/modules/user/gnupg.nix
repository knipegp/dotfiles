{
  pkgs,
  config,
  ...
}:

let
  cfg = config.platform;
  isDarwin = cfg.isDarwin or false;
in
{
  config = {
    home.packages = with pkgs; [ gnupg ];

    services.gpg-agent = {
      enable = true;
      pinentry.package = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gtk2;
      enableBashIntegration = true;
      grabKeyboardAndMouse = false;
    };
  };
}
