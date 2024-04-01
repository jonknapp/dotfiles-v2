{ config, pkgs, ... }:

{
  imports = [
    ../programs/borgmatic.nix
    ../programs/notes.nix
    ../programs/pop-launcher.nix
    ../programs/vscode.nix
  ];

  home.packages = [
    pkgs.gnome42Extensions."clipboard-history@alexsaveau.dev"
    pkgs.gnome42CustomExtensions."caffeine@patapon.info"
  ];
}
