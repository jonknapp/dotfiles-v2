{ config, lib, pkgs, ... }:

let
  op = pkgs.writeShellApplication
    {
      name = "op";
      text = ''
        OP_SERVICE_ACCOUNT_TOKEN="$(${pkgs.rage}/bin/rage --decrypt --identity "${config.home.homeDirectory}/.ssh/id_ed25519" ${
          ../secrets/op.age
        })" ${pkgs._1password-cli}/bin/op "$@"
      '';
    };

  op-env-export = pkgs.writeShellApplication
    {
      name = "op-env-export";
      text = ''
        if [[ "$#" -gt 0 ]]; then
          noteName="$1"
          ${op}/bin/op read --out-file .env "op://development/$noteName/notesPlain"
        else
          echo "You must provide a Note name in the 'development' vault. Ex: \`op-env-export example\`"
        fi

      '';
    };
in
{
  home.packages = [ op op-env-export ];
}
