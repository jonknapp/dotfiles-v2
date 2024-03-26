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
    ../programs/starship.nix
    ../programs/vim.nix
  ];

  programs.bash = {
    inherit shellAliases;
    enable = true;
  };
}
