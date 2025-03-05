{ config, pkgs, ... }:

let
  dotfiles-diff = pkgs.writeShellApplication
    {
      name = "dotfiles-diff";
      text = ''
        (cd "$HOME/.config/home-manager/" && home-manager build)

        # https://discourse.nixos.org/t/nvd-simple-nix-nixos-version-diff-tool/12397/15
        nix store diff-closures "/nix/var/nix/profiles/per-user/$USER/home-manager" "$HOME/.config/home-manager/result"
      '';
    };
  dotfiles-security = pkgs.writeShellApplication
    {
      name = "dotfiles-security";
      runtimeInputs = [ pkgs.vulnix ];
      text = ''
        (cd "$HOME/.config/home-manager/" && home-manager build)

        vulnix "$HOME/.config/home-manager/result"
      '';
    };
in
{
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  # Uncomment once I move to dotfiles v2
  # xdg.configFile."nixpkgs/config.nix".text = ''
  #   { allowUnfree = true; }
  # '';

  home.packages = [ dotfiles-diff dotfiles-security ];
  home.shell.enableBashIntegration = true;

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.mime.enable = false; # workaround for https://github.com/nix-community/home-manager/issues/4682
}
