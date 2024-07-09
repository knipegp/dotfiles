{ ... }:

{
  # Fake tray.service so that services.syncthing.tray works
  systemd = {
    user = {
      targets.tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = [ "graphical-session-pre.target" ];
        };
      };
    };
  };
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
