{
  lib,
  config,
  ...
}:
let
  cfg = config.sys;
in
{
  networking = {
    hostName = cfg.host.name;
    useDHCP = lib.mkDefault true;
    firewall.enable = true;
    networkmanager.enable = true;
  };
}
