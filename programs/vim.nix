{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;

    settings = { number = true; };
  };
}
