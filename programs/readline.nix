{ config, pkgs, ... }:

{
  programs.readline = {
    enable = true;
    extraConfig = ''
      "\C-v": ""
    '';
  };
}
