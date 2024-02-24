{ pkgs, system, ... }:

(final: prev: {
  gnome42CustomExtensions."caffeine@patapon.info" = pkgs.legacyPackages.${system}.gnome42Extensions."caffeine@patapon.info";
})
