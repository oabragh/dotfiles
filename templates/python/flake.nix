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
        { pkgs, ... }:
        {

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              ruff-check.enable = true;
              ruff-format.enable = true;
              taplo.enable = true;
            };
          };

          devShells.default = pkgs.mkShell {
            name = "python-dev";

            packages = with pkgs; [
              python314
              uv
              basedpyright
              ruff
            ];

            env = {
              UV_PYTHON_DOWNLOADS = "never";
              UV_PYTHON = "${pkgs.python314}/bin/python3";
            };

            shellHook = ''
              uv sync

              echo "loaded dev shell."
            '';
          };
        };
    };
}
