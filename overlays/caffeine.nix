{ pkgs, ... }:

(final: prev: {
  gnome42CustomExtensions."caffeine@patapon.info" = pkgs.gnome42Extensions."caffeine@patapon.info";
})
