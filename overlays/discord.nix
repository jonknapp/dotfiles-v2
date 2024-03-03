{ pkgs, ... }:

let
  # xdg-open won't work currently as the XDG_DATA_DIRS that are prepended mess
  # with its ability to open urls.
  xdgOpenWrapper = pkgs.writeScriptBin "xdg-open" ''
    #!${pkgs.stdenv.shell}

    url="$1"

    if [[ $url =~ https://* ]]; then
      ${pkgs.glib}/bin/gdbus call --session \
        --dest org.freedesktop.portal.Desktop \
        --object-path /org/freedesktop/portal/desktop \
        --method org.freedesktop.portal.OpenURI.OpenURI \
        --timeout 5 \
        "" "$url" {}
    else
      echo "Ignoring xdg-open call with $1"
    fi
  '';
in
(final: prev: {
  discord = prev.discord.overrideAttrs (old: rec {
    postFixup = ''
      makeWrapper ${prev.discord}/bin/discord $out/bin/${old.pname} \
        --prefix PATH : "${xdgOpenWrapper}/bin"
    '';
  });
})
