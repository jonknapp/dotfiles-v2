{ inputs, system, ... }:

[
  (import
    ./caffeine.nix
    {
      pkgs = import inputs.nixpkgs-caffeine {
        inherit system;
      };
    })
]
