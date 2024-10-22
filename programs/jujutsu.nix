{ config, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "jon@coffeeandcode.com";
        name = "Jonathan Knapp";
      };
    };
  };
}
