{ inputs, system, ... }:

[
  (import
    ./caffeine.nix
    {
      inherit system;
      pkgs = inputs.nixpkgs-caffeine;
    })
]
