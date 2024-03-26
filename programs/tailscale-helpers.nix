{ config, lib, pkgs, ... }:

let
  cfg = config.programs.tailscale-helpers;

  startTailscale = pkgs.writeShellApplication
    {
      name = "start-tailscale";
      text = ''
        sudo tailscale up ${if cfg.operatorOverride then ''--operator="${config.home.username}"'' else ""} ${if cfg.enableSsh then "--ssh" else ""}
      '';
    };
in
{
  options.programs.tailscale-helpers = {
    enable = lib.mkEnableOption "Tailscale Helpers";

    enableReceiver = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable Tailscale's Taildrop receiver.";
    };

    enableSsh = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable SSH over Tailscale.";
    };

    operatorOverride = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to overide the Tailscale operator to the current user.";
    };

    receiverDirectory = lib.mkOption {
      default = config.xdg.userDirs.download;
      type = lib.types.str;
      description = "Where to store files received by Taildrop.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ startTailscale ];

    systemd.user.services.tailscale-receiver = lib.mkIf cfg.enableReceiver {
      Unit = {
        Description = "File receiver service for Tailscale's Taildrop";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = ''
          tailscale file get --verbose --loop "${cfg.receiverDirectory}"
        '';
      };
    };
  };
}
