{ config, pkgs, ... }:

{
  # Enable udisks2 for disk management
  services.udisks2.enable = true;

  # Polkit rule to allow wheel group users to manage disks with udisksctl
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("wheel")
          && action.id.match("org.freedesktop.udisks2.")
        )
      {
        return polkit.Result.YES;
      }
    });
  '';
}