{ config, pkgs, ... }:

{
  imports = [
    ../programs/borgmatic.nix
    ../programs/vscode.nix
  ];

  home.packages = [
    pkgs.gnome42Extensions."clipboard-history@alexsaveau.dev"
    pkgs.gnome42CustomExtensions."caffeine@patapon.info"
  ];
}
