{ config, lib, pkgs, ... }:

let
  cfg = config.programs.atuin;
in
{
  options.programs.autin = {
    enable = lib.mkEnableOption "atuin";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.atuin ];

    programs.bash.initExtra = ''
      eval "$(atuin init bash)"
    '';
  };
}
