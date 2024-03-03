{ config, pkgs, ... }:

{
  imports = [
    ./desktop-light.nix
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
        slack;
      # todoist-electron
    };
}
