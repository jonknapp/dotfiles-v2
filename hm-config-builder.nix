{ home-manager, nixpkgs, overlays, ... }:

let
  pkgsForSystem = system: import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = overlays system;
  };
in
{ genericLinux ? false, hostname, system, username, modules ? [ ], options ? { }, stateVersion ? "23.11" }:
let
  pkgs = pkgsForSystem system;
  configuration = home-manager.lib.homeManagerConfiguration ({
    inherit pkgs;

    extraSpecialArgs = {
      hostConfig = {
        inherit hostname;
      };
    };

    modules = [
      ./home.nix
      {
        home = {
          inherit stateVersion username;

          homeDirectory = "/home/${username}";
        };
      }
    ] ++ (if (genericLinux) then [ ./profiles/generic-linux.nix ] else [ ]) ++ modules;
  } // options);
in
{
  inherit configuration system;

  name = "${username}@${hostname}";
  package = configuration.activationPackage;
}
