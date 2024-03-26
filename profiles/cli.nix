{ config, pkgs, ... }:

let
  shellAliases = {
    gh = "git-remote-open";
    grep = "grep --color=auto";
    ls = "ls --color=auto";
    open = "xdg-open";
    pbcopy = "${pkgs.xclip}/bin/xclip -selection c";
    pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
    q = "pbpaste | mdquote | pbcopy"; # `quote` as an alias breaks bash
    restart-audio = "sudo alsa reload && sudo service bluetooth restart";
  };
in
{
  imports = [
    ../programs/aws.nix
    ../programs/direnv.nix
    ../programs/git.nix
    ../programs/gpg.nix
    ../programs/heroku.nix
    ../programs/readline.nix
    ../programs/ruby.nix
    ../programs/starship.nix
    ../programs/vim.nix
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      fd
      ripgrep;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.vscode}/bin/code --wait";
  };

  programs.bash = {
    inherit shellAliases;
    enable = true;
  };
}
