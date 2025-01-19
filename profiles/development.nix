{ config, pkgs, ... }:

{
  imports = [
    ../programs/aws.nix
    ../programs/direnv.nix
    ../programs/git.nix
    ../programs/gpg.nix
    ../programs/heroku.nix
    ../programs/http-server.nix
    ../programs/jujutsu.nix
    ../programs/postgres.nix
    ../programs/readline.nix
    ../programs/ruby.nix
    ../programs/security-keys.nix
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      fd
      ripgrep;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.vscode}/bin/code --wait";
  };
}
