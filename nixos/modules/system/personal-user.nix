{ ... }:

{
  config = {
    users.users.griff = {
      isNormalUser = true;
      description = "Griffin Knipe";
      extraGroups = [
        "networkmanager"
        "wheel"
        "data-users" # for NAS disks
        "cdrom" # for blu-ray drive
        "video" # for sunshine
        "input" # for sunshine
        "immich"
      ];
    };
  };
}
