{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    services.sshServer = {

      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of usernames to add authorized SSH keys to";
      };

      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQWTs56/4l02WMPVjlkXedL/IkNL02I9bITqkGKLJRc griff@haleakala"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDTPPtF89kPch8mSf3nWB51RzjjhAYRtGNneHSppnd/ u0_a58@localhost"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzeX3Lawg84+SzQobNR0jpNuO7R4e99wyYB6v7Aa3qW griff@lahaina"
        ];
        description = "List of authorized SSH public keys";
      };
    };
  };

  config = {
    services.openssh.enable = true;

    # Install kitty terminfo for SSH sessions from kitty terminal
    environment.systemPackages = [ pkgs.kitty.terminfo ];

    users.users = lib.genAttrs config.services.sshServer.users (_user: {
      openssh.authorizedKeys.keys = config.services.sshServer.authorizedKeys;
    });

    security.sudo.extraRules = [
      {
        users = [ "ALL" ];
        commands = [
          {
            command = "${config.systemd.package}/bin/systemctl suspend";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/systemctl suspend";
            options = [ "NOPASSWD" ];
          }
        ];
      }
      # Allow admin user to run nixos-rebuild without password
      {
        users = [ "admin" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nix-env";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/switch-to-configuration";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
