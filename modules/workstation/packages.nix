inputs @ {
  pkgs,
  ...
}:
let
  playground = import ../../packages/playground.nix inputs;
in {
  environment.systemPackages = with pkgs; [
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

    # mpv
    # spotify
  ] ++ [
    playground
  ];
}
