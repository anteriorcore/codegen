{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    systems.url = "systems";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "flake-parts";
  };
  outputs =
    { flake-parts, systems, ... }@inputs:
    let
      codegenFlake =
        { ... }:
        {
          flake.flakeModules.default = import ./codegen.nix;
          perSystem =
            { ... }:
            {
              treefmt = import ./nix/treefmt.nix;
            };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        codegenFlake
        inputs.treefmt-nix.flakeModule
        inputs.flake-parts.flakeModules.flakeModules
      ];
    };
}
