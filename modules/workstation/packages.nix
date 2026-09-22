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

      alacritty
      foot

      qbittorrent
      keepassxc
      zed-editor
      android-tools
      brightnessctl
      git-cliff

      spotify
      obsidian
      mpv

      aseprite
      wl-screenrec
      wl-clipboard
      radicle-node
      radicle-desktop
    ]
    ++ [
      playground
    ];
}
