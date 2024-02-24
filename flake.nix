{
  description = "Home Manager configurations";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-caffeine.url = "github:nixos/nixpkgs/9f7d9a55cc9960c029b006444e64e8dfa54a578e";
  };

  outputs = inputs @ { home-manager, nixpkgs, nixpkgs-caffeine, ... }:
    let
      overlays = system: import ./overlays { inherit inputs system; };
      hmConfig = import ./hm-config-builder.nix { inherit home-manager overlays nixpkgs; };
      megaman = hmConfig
        {
          username = "jon";
          hostname = "megaman";
          system = "x86_64-linux";
          genericLinux = true;
          modules = [
            ./profiles/cli.nix
            ./profiles/desktop-full.nix
          ];
        };
    in
    {
      homeConfigurations = {
        ${megaman.name} = megaman.configuration;
      };
      packages.${megaman.system}.${megaman.name} = megaman.package;
    };
}
