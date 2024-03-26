{ config, pkgs, ... }:

let
  customTypesConfg = pkgs.writeText "custom-types" ''
    types {
      application/manifest+json webmanifest;
    }
  '';
  http-server = pkgs.writeScriptBin "http-server" ''
    #!${pkgs.stdenv.shell}

    server() {
      local source_path="$1"
      if [ -z "$1" ]; then
        source_path="$PWD"
      fi
      echo "Simple static server started at http://localhost:8000 from $source_path"
      docker run -p 8000:80 --rm \
        -v "${customTypesConfg}":/etc/nginx/conf.d/custom-types.conf:ro \
        -v "$(cd "$source_path" || exit; echo "$PWD")":/usr/share/nginx/html:ro \
        nginx:alpine
    }

    server $1
  '';
in
{
  home.packages = [ http-server ];
}
