{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, lib, ... }:
        let
          build = pkgs.writeShellScriptBin "build" ''
            mkdir -p "$ROOT/_build"
            ${lib.getExe pkgs.typst} compile "$ROOT/src/<...>.typ" "$ROOT/_build/<...>.pdf"
          '';

          develop = pkgs.writeShellScriptBin "develop" ''
            mkdir -p "$ROOT/_build"

            ${lib.getExe pkgs.typst} watch "$ROOT/src/<...>.typ" "$ROOT/_build/<...>.pdf" &
            TYPST_PID=$!

            env QT_QPA_PLATFORM=xcb ${lib.getExe pkgs.sioyek} "$ROOT/_build/<...>.pdf"

            kill $TYPST_PID
          '';
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              typstyle.enable = true;
            };
          };

          devShells.default = pkgs.mkShellNoCC {
            name = "typst-dev";

            packages = [
              pkgs.typst
              pkgs.tinymist
              pkgs.sioyek
              build
              develop
            ];

            shellHook = ''
              export ROOT=$(${lib.getExe pkgs.git} rev-parse --show-toplevel 2>/dev/null || pwd)

              echo "loaded dev shell."
            '';
          };
        };
    };
}
