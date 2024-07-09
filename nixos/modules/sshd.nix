{ config, lib, ... }:

{
  services.openssh = { enable = true; };
  users.users.griff.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7SUX5TTsnms0QlawH8uTjEVFiYJTcOH544pYUxYuXr griff@lihue"
  ];
}
