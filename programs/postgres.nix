{ config, pkgs, ... }:

{
  home.sessionVariables = {
    PSQLRC = "~/${config.xdg.configFile."pg/psqlrc".target}";
  };

  xdg.configFile."pg/psqlrc".text = ''
    \pset null '[NULL]'
  '';
}
