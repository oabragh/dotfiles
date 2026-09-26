{ lib, ... }:
{
  options.domain = lib.mkOption {
    type = lib.types.str;
    description = "Global domain name for server deployments and services";
  };
}
