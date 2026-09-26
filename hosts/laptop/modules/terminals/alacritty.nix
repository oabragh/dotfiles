{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.alacritty
  ];

  # TODO: configure alacritty
}
