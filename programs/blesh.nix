{ config, lib, pkgs, ... }:

let
  cfg = config.programs.blesh;
in
{
  options.programs.blesh = {
    enable = lib.mkEnableOption "ble.sh";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.blesh ];

    programs.bash.initExtra = ''
      source "$(blesh-share)"/ble.sh
    '';
  };
}
