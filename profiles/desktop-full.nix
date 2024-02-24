{ config, pkgs, ... }:

{
  imports = [
    ./desktop-light.nix
  ];

  home.packages =
    builtins.attrValues {
      inherit (pkgs)
        discord
        google-chrome
        slack;
    };
}
