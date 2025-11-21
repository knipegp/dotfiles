{ ... }:

{
  config = {
    users.users.griff = {
      isNormalUser = true;
      description = "Griffin Knipe";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
