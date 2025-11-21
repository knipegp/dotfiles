{ pkgs, ... }:

{

  home.packages = with pkgs; [
    wakeonlan
    (writeShellScriptBin "wake-haleakala" ''
      wakeonlan -i haleakala 24:4b:fe:96:37:65
    '')
    (writeShellScriptBin "sleep-haleakala" ''
      ssh griff@haleakala sudo systemctl suspend
    '')
  ];

}
