{ config, pkgs, ... }:

let
  shellAliases = {
    gh = "git-remote-open";
    grep = "grep --color=auto";
    ls = "ls --color=auto";
    nix-gc = "nix-collect-garbage --delete-older-than 30d";
    open = "xdg-open";
    pbcopy = "${pkgs.xclip}/bin/xclip -selection c";
    pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
    q = "pbpaste | mdquote | pbcopy"; # `quote` as an alias breaks bash
    restart-audio = "sudo alsa reload && sudo service bluetooth restart";
  };
in
{
  imports = [
    ../programs/blesh.nix
    ../programs/starship.nix
    ../programs/vim.nix
  ];

  programs.atuin = {
    enable = true;
    # NOTE: To get this to work the first time you need to change to another shell (like `sh`)
    #       then remove the default config file (ex: `rm ~/.config/atuin/config.toml`)
    #       and run `home-manager switch`.
    settings.history_filter = [
      "RAILS_MASTER_KEY"
    ];
  };
  programs.bash = {
    inherit shellAliases;
    enable = true;
  };
  programs.blesh.enable = false;
}
