inputs@{
  lib,
  pkgs,
  ...
}:
let
  playground = import ../../packages/playground.nix inputs;
in
{
  environment.systemPackages =
    with pkgs;
    [
      # my favourite gnomeware bloat
      gnome-calculator
      nautilus
      loupe
      papers
      showtime
      decibels
      rnote
      impression

      # terminals
      alacritty
      foot

      qbittorrent
      # TODO: i don't want keepass anymore
      keepassxc
      zed-editor
      android-tools
      brightnessctl
      git-cliff

      # spotify
      mpv

      (ani-cli.overrideAttrs (oldAttrs: {
        src = fetchFromGitHub {
          owner = "Dhairya3391";
          repo = "ani-cli";
          rev = "temp-fix";
          hash = "sha256-b/e//d1cafxBbYfOHc0lbYkUt/jT/MjIB7lFRfohdOA=";
        };
      }))
    ]
    ++ [
      playground
    ];
}
