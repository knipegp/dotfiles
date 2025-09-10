{ lib, config, ... }:

{
  options = {
    users.personalUser = {
      enableSshLogin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable SSH login for the personal user with authorized keys";
      };
    };
  };

  config = {
    services.openssh.enable = lib.mkIf config.users.personalUser.enableSshLogin true;

    users.users.griff = {
      isNormalUser = true;
      description = "Griffin Knipe";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = lib.mkIf config.users.personalUser.enableSshLogin [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7SUX5TTsnms0QlawH8uTjEVFiYJTcOH544pYUxYuXr griff@lihue"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDTPPtF89kPch8mSf3nWB51RzjjhAYRtGNneHSppnd/ u0_a58@localhost"
      ];
    };
  };
}
