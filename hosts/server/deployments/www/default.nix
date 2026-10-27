{ config, ... }:
let
  ports = config.modules.server.ports;
  socialServerPort = ports.socialServer;
  matrixServerPort = ports.matrixServer;
in
{
  services.nginx.virtualHosts = {
    "${config.domain}" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [ "www.${config.domain}" ];

      locations = {
        "^~ /.well-known/webfinger/" = {
          proxyPass = "http://127.0.0.1:${toString socialServerPort}";
        };

        "^~ /.well-known/nodeinfo/" = {
          proxyPass = "http://127.0.0.1:${toString socialServerPort}";
        };

        "^~ /.well-known/host-meta/" = {
          proxyPass = "http://127.0.0.1:${toString socialServerPort}";
        };

        "^~ /.well-known/matrix/" = {
          proxyPass = "http://127.0.0.1:${toString matrixServerPort}";
        };
      };
    };
  };
}
