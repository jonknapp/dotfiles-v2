{ config, hostConfig, pkgs, ... }:

let
  borgmaticConfig = (import ../files/borgbase.nix { homeDirectory = config.home.homeDirectory; }).${hostConfig.hostname};
  borg-backup = pkgs.writeShellApplication
    {
      name = "borg-backup";
      text = ''
        # set -o xtrace
        # set -euo pipefail
        # shopt -s inherit_errexit

        ssid="$(${pkgs.wirelesstools}/bin/iwgetid -r)"
        if [[ "$ssid" == "Coffee and Code" ]]; then
          echo "Starting backup..."
          "${pkgs.borgmatic}/bin/borgmatic" create --list
          echo "Backup complete."
        else
          echo "Skipping backup; ssid is '$ssid'"
        fi
      '';
    };
in
{
  systemd.user.services.borg-backup = {
    Unit = {
      Description = "Backup files to borgbase";
      After = "network-online.target";
    };

    Service = {
      Type = "oneshot";
      Nice = 15;
      IOSchedulingClass = "best-effort";
      ExecStartPre = "/bin/sleep 10";
      ExecStart = ''
        /bin/sh -c ${borg-backup}/bin/borg-backup
      '';
    };
  };

  systemd.user.timers.borg-backup = {
    Unit = {
      Description = "Backup files to borgbase";
      Wants = [ "network-online.target" ];
    };

    Timer = {
      OnCalendar = "hourly";
      AccuracySec = "5min";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  xdg.configFile."borgmatic.d/default.yaml".text = ''
    source_directories:
        - '~'

    repositories:
        - path: ${borgmaticConfig.path}
          label: borgbase

    exclude_patterns:
        - '*/NO_BACKUP/*'
        - ~/.local/share/Trash/
        - ~/.local/share/docker/
        - '*.pyc'
        - ~/.cache/
        - ~/.var/app/com.valvesoftware.Steam/
        - ~/.var/app/com.heroicgameslauncher.hgl/
        - ~/Dropbox/
        - ~/.dropbox/

    exclude_if_present:
        - .nobackup

    one_file_system: true

    compression: auto,zstd
    encryption_passcommand: ${pkgs.rage}/bin/rage --decrypt -i ${borgmaticConfig.sshKey} ${borgmaticConfig.passphraseSecret}
    archive_name_format: '{hostname}-{now:%Y-%m-%d-%H%M%S}'
    # match_archives: sh:{hostname}-*

    retries: 5
    retry_wait: 5

    keep_daily: 3
    keep_weekly: 4
    keep_monthly: 12
    keep_yearly: 2

    before_backup:
        - echo "`date` - Starting backup"

    after_backup:
        - echo "`date` - Finished backup"
  '';
}
