{ inputs, system, ... }:

let
  pkgsForSystem = { nixpkgs, system }: import nixpkgs {
    inherit system;
  };
in
[
  (import
    ./caffeine.nix
    {
      pkgs = pkgsForSystem { inherit system; nixpkgs = inputs.nixpkgs-caffeine; };
    })
  (import
    ./discord.nix
    {
      pkgs = pkgsForSystem { inherit system; nixpkgs = inputs.nixpkgs; };
    })
  (import
    ./todoist-electron.nix
    {
      pkgs = pkgsForSystem { inherit system; nixpkgs = inputs.nixpkgs; };
    })
]
