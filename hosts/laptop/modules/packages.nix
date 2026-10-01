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
      wl-clipboard
      sherlock
      git-cliff
      helix
      yazi

      spotify
      obsidian
    ]
    ++ gnomeBloat
    ++ [
      playground
    ];

  programs.gpu-screen-recorder.enable = true;
}
