{ config, pkgs, ... }:

let
  toggle-dock = pkgs.writeShellApplication
    {
      name = "toggle-dock";
      text = ''
        existing=$(dconf read /org/gnome/shell/extensions/dash-to-dock/manualhide)
        newValue="true"
        if [ "$existing" = "true" ]; then
          newValue="false"
        fi
        dconf write /org/gnome/shell/extensions/dash-to-dock/manualhide "$newValue"
      '';
    };
  toggleDockDesktop = pkgs.makeDesktopItem {
    name = "toggle-dock";
    desktopName = "Toggle Dock";
    exec = "${toggle-dock}/bin/toggle-dock";
    icon = "/usr/share/icons/Pop/128x128/apps/application-default-icon.svg";
  };
in
{
  home.packages = [ toggleDockDesktop ];
}
