{ config, pkgs, ... }:

{
  imports = [
    ../programs/aws.nix
    ../programs/direnv.nix
    ../programs/git.nix
    ../programs/gpg.nix
    ../programs/heroku.nix
    ../programs/readline.nix
    ../programs/ruby.nix
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
