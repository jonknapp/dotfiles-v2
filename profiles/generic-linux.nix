{ config, pkgs, ... }:

{
  home.packages = [ pkgs.xdg-utils ];

  systemd.user.systemctlPath = "/usr/bin/systemctl";
  targets.genericLinux.enable = true;

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "gtk" ];
      };
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };
}
