{ config, pkgs, ... }:

let
  heroku-pg-import = pkgs.writeShellApplication
    {
      name = "heroku-postgres-import";
      text = ''
        pg_user=postgres
        prefix="${pkgs.docker-compose}/bin/docker-compose exec -T postgres"

        if [ -f "flake.nix" ]; then
          if grep -q devenv < flake.nix
          then
            pg_user="$USER"
            prefix=""
          fi
        fi

        $prefix psql -U "$pg_user" -d app_dev -c "CREATE SCHEMA IF NOT EXISTS heroku_ext;"

        # NOTE: pg_restore arguments that were removed to also run with devenv: --exit-on-error --if-exists
        $prefix pg_restore --verbose --clean --no-acl --no-owner -U "$pg_user" -d app_dev < latest.dump
      '';
    };
in
{
  home.packages = builtins.attrValues { inherit (pkgs) heroku; } ++ [ heroku-pg-import ];

  home.sessionVariables = { HEROKU_ORGANIZATION = "coffeeandcode"; };
}
