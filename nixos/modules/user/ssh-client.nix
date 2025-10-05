{ pkgs, ... }:

{

  home.packages = with pkgs; [
    wakeonlan
    (writeShellScriptBin "wake-haleakala" ''
      wakeonlan -i 10.200.0.4 24:4b:fe:96:37:65
    '')
    (writeShellScriptBin "sleep-haleakala" ''
      ssh griff@haleakala sudo systemctl suspend
    '')
  ];

}
