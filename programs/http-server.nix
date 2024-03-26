{ config, pkgs, ... }:

let
  http-server = pkgs.writeScriptBin "http-server" ''
    #!${pkgs.stdenv.shell}

    server() {
      local source_path="$1"
      if [ -z "$1" ]; then
        source_path="$PWD"
      fi
      echo "Simple static server started at http://localhost:8000 from $source_path"
      docker run -p 8000:80 --rm \
        -v "$HOME/${
          config.xdg.configFile."http-server/custom-types.conf".target
        }":/etc/nginx/conf.d/custom-types.conf:ro \
        -v "$(cd "$source_path" || exit; echo "$PWD")":/usr/share/nginx/html:ro \
        nginx:alpine
    }

    server $1
  '';
in
{
  home.packages = [ http-server ];

  xdg.configFile."http-server/custom-types.conf".text = ''
    types {
      application/manifest+json webmanifest;
    }
  '';
}
