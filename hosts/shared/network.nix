{
  lib,
  ...
}:
{
  networking = {
    useDHCP = lib.mkDefault true;
    firewall.enable = true;
  };
}
