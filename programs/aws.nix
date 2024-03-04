{ config, lib, pkgs, ... }:

let
  decrypt-aws-config = pkgs.writeShellApplication
    {
      name = "decrypt-aws-config";
      text = ''
        mkdir -p "${config.home.homeDirectory}/.aws"
        ${pkgs.rage}/bin/rage --decrypt --identity "${config.home.homeDirectory}/.ssh/id_ed25519" --output "${config.home.homeDirectory}/.aws/config" ${
          ../secrets/aws-config.age
        }
        chmod 444 "${config.home.homeDirectory}/.aws/config"
      '';
    };
in
{
  home.packages = builtins.attrValues
    {
      inherit (pkgs) awscli2 aws-vault;
    };

  systemd.user.services.secret-extractor = lib.mkIf (pkgs.stdenv.isLinux) {
    Unit = { Description = "secret extractor"; };

    Install = { WantedBy = [ "default.target" ]; };

    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = ''
        /bin/sh -c ${decrypt-aws-config}/bin/decrypt-aws-config
      '';
      ExecStartPre = ''/usr/bin/test ! -f "${config.home.homeDirectory}/.aws/config"'';
      ExecStop = ''rm "${config.home.homeDirectory}/.aws/config"'';
    };
  };
}
