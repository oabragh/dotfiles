{ lib, ... }:
{
  options.domain = lib.mkOption {
    type = lib.types.str;
    description = "Global domain name for server deployments and services";
  };

  options.modules.server.ports = lib.mkOption {
    type = lib.types.attrsOf lib.types.port;
    default = {
      forgejo = 3001;
      miniflux = 3002;
      stalwartJmap = 3003;
      stalwartMgmt = 3004;
      bulwark = 3005;
      radicleHttpd = 3006;
      matrixServer = 3007;
      socialServer = 3008;
      matrixFederation = 8448;
      radicleSeed = 8776;
    };
    description = "Central registry for ports to prevent collisions";
  };
}
