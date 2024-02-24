{ config, pkgs, ... }:

{
  imports = [
    ../programs/vscode.nix
  ];

  home.packages = [
    pkgs.gnome42Extensions."clipboard-history@alexsaveau.dev"
    pkgs.gnome42CustomExtensions."caffeine@patapon.info"
  ];
}
