{ config, pkgs, ... }:

let
  notes = pkgs.writeShellApplication
    {
      name = "notes";
      runtimeInputs = [ pkgs.vscode ];
      text = ''
        notes_path="$HOME/Dropbox/Notes"
        if [ -d "$notes_path" ]; then
          code "$notes_path"
        else
          echo "$notes_path does not exist; skipping"
        fi
      '';
    };
in
{ home.packages = [ notes ]; }
