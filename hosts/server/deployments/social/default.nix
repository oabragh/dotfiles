{ config, self, ... }:
let
  ports = config.modules.server.ports;
  socialDomain = "social.${config.domain}";
  socialServerPort = ports.socialServer;
in
{
  services.gotosocial = {
    enable = true;
    setupPostgresqlDB = true;

    settings = {
      application-name = "Fediverse";
      host = socialDomain;
      protocol = "https";
      bind-address = "127.0.0.1";
      port = socialServerPort;
      account-domain = config.domain;
    };
  };

  services.nginx.virtualHosts = {
    "${socialDomain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString socialServerPort}";
        proxyWebsockets = true;
      };
    };
  };
}
