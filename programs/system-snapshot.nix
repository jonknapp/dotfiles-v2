{ config, pkgs, ... }:
let
  system-snapshot = pkgs.writeShellApplication
    {
      name = "system-snapshot";
      text = ''
        # set -o xtrace
        # set -euo pipefail
        # shopt -s inherit_errexit

        mkdir -p "${config.xdg.configHome}/system-snapshot"

        echo "Storing backup of apt"
        apt list --installed > "${config.xdg.configHome}/system-snapshot/apt.txt"

        echo "Storing backup of flatpak"
        flatpak list > "${config.xdg.configHome}/system-snapshot/flatpak.txt"

        echo "Storing backup of gnome-extensions"
        gnome-extensions list --enabled > "${config.xdg.configHome}/system-snapshot/gnome.txt"

        echo "Storing gnome settings"
        dconf dump / > "${config.xdg.configHome}/system-snapshot/dconf.settings"
      '';
    };
in
{
  systemd.user.services.system-snapshot = {
    Unit = { Description = "system snapshot"; };

    Install = { WantedBy = [ "default.target" ]; };

    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = ''
        /bin/sh -c ${system-snapshot}/bin/system-snapshot
      '';
      ExecStartPre = "/bin/sleep 10";
    };
  };
}
