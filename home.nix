{ config, pkgs, ... }:

{
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  # Uncomment once I move to dotfiles v2
  # xdg.configFile."nixpkgs/config.nix".text = ''
  #   { allowUnfree = true; }
  # '';

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.mime.enable = false; # workaround for https://github.com/nix-community/home-manager/issues/4682
}
