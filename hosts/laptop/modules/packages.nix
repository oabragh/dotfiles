inputs@{
  pkgs,
  ...
}:
let
  playground = import ../../../packages/playground.nix inputs;

  gnomeBloat = with pkgs; [
    gnome-calculator
    nautilus
    loupe
    decibels
    rnote
  ];
in
{
  environment.systemPackages =
    with pkgs;
    [
      qbittorrent
      keepassxc
      zed-editor
      aseprite
      sioyek
      mpv

      android-tools
      brightnessctl
      gpu-screen-recorder
      wl-clipboard
      sherlock
      git-cliff

      spotify
      obsidian
    ]
    ++ gnomeBloat
    ++ [
      playground
    ];
}
