{
  outputs = inputs: {
    nixosConfigurations = let
      mkCommon = hostname: [
        ./hosts/${hostname}
        ./modules/common
      ];
    in {
      machine = inputs.nixpkgs.lib.nixosSystem {
        modules = mkCommon "machine" ++ [
          ./modules/browsing
          ./modules/graphical
          ./modules/workstation
        ];

        specialArgs = {
          inherit inputs;
        };
      };

      vps = inputs.nixpkgs.lib.nixosSystem {
        modules = mkCommon "vps" ++ [
          ./modules/deployments/ssh
          ./modules/deployments/git
          ./modules/deployments/rss
          ./modules/deployments/mail
          ./modules/deployments/vault
          ./modules/deployments/element

          # Necessary for the deployments to function (nginx setup)
          ./modules/deployments
        ];

        specialArgs = {
          inherit inputs;
        };
      };
    };

    templates = rec {
      python = {
        path = ./templates/python;
        description = "Python project starter template using uv";
      };
      rust = {
        path = ./templates/rust;
        description = "Rust project starter template";
      };
      typst = {
        path = ./templates/typst;
        description = "Simple typst template";
      };

      default = python;
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qtengine = {
      url = "github:kossLAN/qtengine";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # repo size is 1.1gb 💀
    # qylock = {
    #   url = "github:Darkkal44/qylock";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
}
