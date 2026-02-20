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
            { config, self', ... }:
            {
              treefmt = import ./nix/treefmt.nix;
              # Demonstration:
              codegen = {
                enable = true;
                root = ./.;
                files.".nixpkgs.version".text = "${inputs.nixpkgs.shortRev}\n";
              };
            };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        ./codegen.nix
        codegenFlake
        inputs.treefmt-nix.flakeModule
        inputs.flake-parts.flakeModules.flakeModules
      ];
    };
}
