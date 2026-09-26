{ lib, ... }:
{
  options.domain = lib.mkOption {
    type = lib.types.str;
    default = "oabragh.dedyn.io";
    description = "Global domain name for server deployments and services";
  };
}
