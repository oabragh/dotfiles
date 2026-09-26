{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.foot
  ];

  # TODO: configure foot
}
