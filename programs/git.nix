{ config, pkgs, ... }:

{
  home.packages = builtins.attrValues { inherit (pkgs) git; }
    ++ (if pkgs.stdenv.isLinux then
    builtins.attrValues { inherit (pkgs) sublime-merge; }
  else
    [ ]);

  xdg.configFile."ssh/allowed_signers".text =
    ''${config.programs.git.userEmail} namespaces="git" sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKgPs5dWLchzE1FwvhUrmhD2ED+apqOxnpg9dBJaFL6eAAAAEXNzaDpibHVlLXNvbG9rZXky'';

  programs.git = {
    enable = true;
    userEmail = "jon@coffeeandcode.com";
    userName = "Jonathan Knapp";

    aliases = {
      pretty =
        "log --graph --decorate --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      sha = ''log --format="%H" --max-count=1'';
    };

    extraConfig = {
      advice.skippedCherryPicks = false;
      core.editor = "${pkgs.vscode}/bin/code --wait";
      diff.tool = "bc";
      difftool.bc.trustExitCode = true;
      difftool.prompt = false;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/${config.xdg.configFile."ssh/allowed_signers".target}";
      help.autocomplete = 1;
      help.autocorrect = 20;
      init.defaultBranch = "main";
      merge.tool = "smerge";
      mergetool = {
        smerge = {
          cmd = ''smerge mergetool "$BASE" "$LOCAL" "REMOTE" -o "$MERGED"'';
          trustExitCode = true;
        };
      };
      pull.ff = "only";
      push.autoSetupRemote = true;
      push.default = "simple";
    };

    ignores = [
      ".byebug_history"
      ".DS_Store"
      ".elixir_ls/"
      ".vscode/"
      "npm-debug.log"
      "project.code-workspace"
    ];

    signing = {
      key = "~/.ssh/id_ed25519_sk.pub";
      signByDefault = true;
    };
  };
}
