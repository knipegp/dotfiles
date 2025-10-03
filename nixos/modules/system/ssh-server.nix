{ lib, config, ... }:

{
  options = {
    services.sshServer = {

      user = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Username to add authorized SSH keys to";
      };

      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7SUX5TTsnms0QlawH8uTjEVFiYJTcOH544pYUxYuXr griff@lihue"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDTPPtF89kPch8mSf3nWB51RzjjhAYRtGNneHSppnd/ u0_a58@localhost"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMzeX3Lawg84+SzQobNR0jpNuO7R4e99wyYB6v7Aa3qW griff@lahaina"
        ];
        description = "List of authorized SSH public keys";
      };
    };
  };

  config = {
    services.openssh.enable = true;

    users.users.${config.services.sshServer.user} = {
      openssh.authorizedKeys.keys = config.services.sshServer.authorizedKeys;
    };
  };
}
