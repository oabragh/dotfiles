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
        "= /.well-known/webfinger" = {
          return = "301 https://social.${config.domain}$request_uri";
        };

        "= /.well-known/nodeinfo" = {
          return = "301 https://social.${config.domain}$request_uri";
        };

        "= /.well-known/host-meta" = {
          return = "301 https://social.${config.domain}$request_uri";
        };

        "^~ /.well-known/matrix/" = {
          proxyPass = "http://127.0.0.1:${toString matrixServerPort}";
        };
      };
    };
  };
}
