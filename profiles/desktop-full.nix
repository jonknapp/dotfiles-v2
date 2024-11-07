{ config, pkgs, ... }:

{
  imports = [
    ./desktop-light.nix
    ../programs/docker.nix
    ../programs/steam.nix
    ../programs/system-snapshot.nix
    ../programs/tailscale-helpers.nix
  ];

  home.packages =
    builtins.attrValues {
      inherit (pkgs)
        borgmatic
        discord
        gcolor3
        google-chrome
        inkscape
        kdiff3
        nix-tree
        slack
        tigervnc;
      # todoist-electron
    };

  programs.docker = { enable = true; rootless = true; };
  programs.tailscale-helpers.enable = true;
}
