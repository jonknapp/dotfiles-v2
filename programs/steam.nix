{ config, pkgs, ... }:

{
  home.packages = builtins.attrValues { inherit (pkgs) protonup-ng; };

  home.file.".config/protonup/config.ini".text = ''
    [protonup]
    installdir = ${config.home.homeDirectory}/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d/
  '';
}
