{ config, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      email = "jon@coffeeandcode.com";
      name = "Jonathan Knapp";
    };
  };
}
