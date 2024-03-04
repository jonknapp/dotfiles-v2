{ config, pkgs, ... }:

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
      ExecStart = "${pkgs.borgmatic}/bin/borgmatic create --list";
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
        - path: ssh://k054fh3a@k054fh3a.repo.borgbase.com/./repo
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
    encryption_passcommand: ${pkgs.rage}/bin/rage --decrypt -i ${config.home.homeDirectory}/.ssh/id_ed25519 ${../secrets/borg-passphrase.age}
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
