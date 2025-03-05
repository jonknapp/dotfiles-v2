{ config, pkgs, ... }:

{
  home.packages = builtins.attrValues {
    inherit (pkgs) fira-code;
  };

  programs.starship = {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      add_newline = false;
      scan_timeout = 10;

      character = { success_symbol = "☕"; };
      docker_context = { format = "via [$symbol]($style) "; symbol = "🐳"; };
    };
  };
}
