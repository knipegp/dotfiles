{ pkgs, ... }:

{
  # See https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  # See https://wiki.hyprland.org/Useful-Utilities/Must-have/
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    dbus # make dbus-update-activation-environment available in the path
    polkit_gnome # polkit authentication agent
    xdg-utils # for opening default programs when clicking links
    pavucontrol
    libsForQt5.qt5.qtwayland
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # wireplumber = {
    #   enable = true;
    #   configPackages = [
    #     (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-displayport-audio.conf" ''
    #       monitor.alsa.rules = [
    #         {
    #           matches = [
    #             {
    #               # Match the AMD GPU HDMI/DP audio device
    #               device.name = "~alsa_card.pci-0000_0b_00.1"
    #             }
    #           ]
    #           actions = {
    #             update-props = {
    #               # Enable HDMI 5 profile automatically
    #               api.alsa.use-acp = true
    #               device.profile = "output:hdmi-stereo-extra4"
    #             }
    #           }
    #         }
    #       ]
    #     '')
    #   ];
    # };
  };

  # Enable the gnome-keyrig secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      });
    '';
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

}
