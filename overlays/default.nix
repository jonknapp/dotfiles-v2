{ inputs, system, ... }:

[
  (import
    ./caffeine.nix
    {
      pkgs = import inputs.nixpkgs-caffeine {
        inherit system;
      };
    })
  (import
    ./discord.nix
    {
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
    })
]
