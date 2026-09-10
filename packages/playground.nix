# Sometimes i need to use python or a specific package as quick as possible
# but a `nix shell` is not always doable (e.g. when there's no wifi)
# so this is kind of like a "cached" nix shell except it's a fhs environment.
# you could just run `play` and you get a set of ready packages
#
# If you think there's a better way please let me know.

{ pkgs, ... }:
let
  base = pkgs.appimageTools.defaultFhsEnvArgs;

  pythonEnv = pkgs.python314.withPackages (
    ps: with ps; [
      numpy
      pandas
      scipy
      matplotlib
      requests
      rich
      # ...
    ]
  );

  qtEnv = pkgs.qt6.env "qt6-env" [
    pkgs.qt6.qtdeclarative
    # ...
  ];
in pkgs.buildFHSEnv {
    name = "play";

    targetPkgs =
      pkgs:
      (base.targetPkgs pkgs)
      ++ (with pkgs; [
        pythonEnv
        qtEnv
        julia
        clang
        fish
        cowsay
      ]);

    profile = ''
      echo -e "Welcome to the Upside Down..." | cowsay -f sus
    '';

    runScript = "${pkgs.fish}/bin/fish";
  }
