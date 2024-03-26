{
  description = "Home Manager configurations";

  inputs = {
    git-remote-open = {
      url = "github:CoffeeAndCode/git-remote-open";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mdquote = {
      url = "github:CoffeeAndCode/mdquote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-caffeine.url = "github:nixos/nixpkgs/9f7d9a55cc9960c029b006444e64e8dfa54a578e";
  };

  outputs = inputs @ { home-manager, nixpkgs, ... }:
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
            ./profiles/development.nix
            ({ pkgs, ... }: {
              home.packages = [
                inputs.git-remote-open.defaultPackage.${pkgs.system}
                inputs.mdquote.defaultPackage.${pkgs.system}
              ];
            })
          ];
        };
      pop-robot = hmConfig
        {
          username = "jon";
          hostname = "pop-robot";
          system = "x86_64-linux";
          genericLinux = true;
          modules = [
            ./profiles/cli.nix
            ./profiles/desktop-full.nix
            ./profiles/development.nix
            ({ pkgs, ... }: {
              home.packages = [
                inputs.git-remote-open.defaultPackage.${pkgs.system}
                inputs.mdquote.defaultPackage.${pkgs.system}
              ];
            })
          ];
        };
    in
    {
      homeConfigurations = {
        ${megaman.name} = megaman.configuration;
        ${pop-robot.name} = pop-robot.configuration;
      };
      packages = nixpkgs.lib.recursiveUpdate
        {
          ${megaman.system}.${megaman.name} = megaman.package;
        }
        {
          ${pop-robot.system}.${pop-robot.name} = pop-robot.package;
        };
    };
}
