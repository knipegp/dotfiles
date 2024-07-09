{ pkgs, ... }:

{
  home.packages = with pkgs; [ gnupg ];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gtk2;
    enableBashIntegration = true;
    grabKeyboardAndMouse = false;
  };
}
