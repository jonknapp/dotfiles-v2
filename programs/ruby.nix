{ config, pkgs, ... }:

{
  home.file.".irbrc".text = ''
    IRB.conf[:SAVE_HISTORY] = 25
  '';

  # xdg.configFile."rails/railsrc".text = ''
  #   --database=postgresql
  #   --skip-jbuilder
  #   --skip-spring
  # '';
}
