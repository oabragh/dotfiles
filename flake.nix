{
  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      subDirs =
        dir:
        builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./${dir}));

      system = "x86_64-linux";

      pkgs = import inputs.nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations =
        let
          mkHost =
            hostname:
            lib.nixosSystem {
              modules = [
                ./hosts/${hostname}
                ./hosts/shared
                (inputs.agenix.nixosModules.default)
              ];

              specialArgs = {
                inherit inputs;
                keys = import ./secrets/keys.nix;
              };
            };
        in
        lib.genAttrs (builtins.filter (i: i != "shared") (subDirs "hosts")) mkHost;

      templates =
        let
          mkTemplate = name: {
            ${name} = {
              path = ./templates/${name};
            };
          };
        in
        lib.genAttrs (subDirs "templates") mkTemplate;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixfmt-tree
          pkgs.nixfmt
        ];
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qtengine = {
      url = "github:kossLAN/qtengine";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
