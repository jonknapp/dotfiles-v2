{ config, pkgs, ... }:

let
  # Loads security key for ssh usage with git.
  load-ssh-key = pkgs.writeScriptBin "load-ssh-key" ''
    #!${pkgs.stdenv.shell}

    systemctl restart pcscd
    ssh-add -e /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
    ssh-add -s /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
  '';

  # Unloads security key for ssh usage with git.
  unload-ssh-key = pkgs.writeScriptBin "unload-ssh-key" ''
    #!${pkgs.stdenv.shell}

    ssh-add -d -e /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
    ssh-add -d -s /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
  '';
in
{
  home.packages = [ load-ssh-key unload-ssh-key ];
}
