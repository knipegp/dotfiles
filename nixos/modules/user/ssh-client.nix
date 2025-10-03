{ pkgs, ... }:

{

  home.packages = with pkgs; [
    (writeShellScriptBin "wake-haleakala" ''
      ssh root@volcano ./wake-haleakala.sh
    '')
    (writeShellScriptBin "sleep-haleakala" ''
      ssh griff@haleakala sudo systemctl suspend
    '')
  ];

}
