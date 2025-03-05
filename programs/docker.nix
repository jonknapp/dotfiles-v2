{ config, lib, pkgs, ... }:

# NOTE: This requires manual configuration to get Docker rootless to work on
#       something like PopOS.
#
#       sudo apt-get install -y uidmap
#       echo "jon:231072:65536" | sudo tee -a /etc/subgid
#       echo "jon:231072:65536" | sudo tee -a /etc/subuid

let
  cfg = config.programs.docker;

  dockerGC = pkgs.writeScriptBin "docker-gc" ''
    #!${pkgs.stdenv.shell}

    docker container prune --force
    docker image prune --all --force
    docker network prune --force

    if docker volume ls --filter dangling=true -q | grep -Eq -e '\w{64}'; then
    	docker volume rm "$(docker volume ls --filter dangling=true -q | grep -E -e '\w{64}')"
    fi
  '';

  backupVolume = pkgs.writeScriptBin "docker-volume-backup" ''
    #!${pkgs.stdenv.shell}

    volume_name="$1"
    if [ -z $volume_name ]; then
      echo "The name of a Docker volume is required."
      echo "USAGE: docker-volume-backup my-example-volume-name"
      exit 1
    fi

    docker run --rm \
      --volume $volume_name:/data \
      --volume $(pwd):/backup ubuntu \
      tar -zcvf /backup/$volume_name.tar /data
  '';

  restoreVolume = pkgs.writeScriptBin "docker-volume-restore" ''
    #!${pkgs.stdenv.shell}

    volume_name="$1"
    if [ -z $volume_name ]; then
      echo "The name of a Docker volume is required."
      echo "USAGE: docker-volume-restore my-example-volume-name"
      exit 1
    fi

    docker run --rm \
      --volume $volume_name:/data \
      --volume $(pwd):/backup ubuntu \
      tar xvf /backup/$volume_name.tar -C /data --strip 1
  '';
in
{
  options.programs.docker = {
    enable = lib.mkEnableOption "Docker";

    enableBashIntegration = lib.mkOption {
      default = config.home.shell.enableBashIntegration;
      type = lib.types.bool;
      description = "Whether to enable Bash integration.";
    };

    enableSystemdDockerRootless = lib.mkOption {
      default = cfg.rootless;
      type = lib.types.bool;
      description = "Whether to install systemd service to start/stop rootless Docker.";
    };

    rootless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use rootless verison of Docker.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ backupVolume pkgs.docker-compose dockerGC restoreVolume ] ++ (if cfg.rootless then [ pkgs.docker ] else [ ]);

    programs.bash.initExtra = lib.mkIf cfg.enableBashIntegration ''
      export DOCKER_HOST="unix:///run/user/$(id --user)/docker.sock"
    '';

    systemd.user.services.docker-rootless = lib.mkIf cfg.enableSystemdDockerRootless {
      Unit = { Description = "Docker rootless"; };

      Install = { WantedBy = [ "default.target" ]; };

      Service = {
        Type = "simple";
        ExecStart = ''
          /bin/sh -c ${pkgs.docker}/bin/dockerd-rootless
        '';
      };
    };
  };
}
