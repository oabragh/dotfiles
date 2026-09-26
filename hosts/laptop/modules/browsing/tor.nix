{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.tor-browser
  ];

  # TODO: configure things settings here
}
