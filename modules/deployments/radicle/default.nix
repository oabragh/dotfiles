{ config, ... }:
let
  cfg = config.sys;
  domain = cfg.domain;

  radicleSeedPort = 3007;
  radicleHttpdPort = 3008;
in
{
  services.radicle = {
    enable = true;

    privateKey = "/var/lib/radicle/keys/radicle";
    publicKey = "/var/lib/radicle/keys/radicle.pub";

    node = {
      listenAddress = "[::]";
      listenPort = radicleSeedPort;
      openFirewall = true;
    };

    httpd = {
      enable = true;
      listenAddress = "127.0.0.1";
      listenPort = radicleHttpdPort;
    };

    settings = {
      publicExplorer = "https://code.${domain}/nodes/$host/$rid$path";

      node = {
        alias = "code.${domain}";
        externalAddresses = [ "code.${domain}:${toString radicleSeedPort}" ];
        seedingPolicy = {
          default = "block";
          scope = "all";
        };
      };
    };
  };

  services.nginx.virtualHosts = {
    "code.${domain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString radicleHttpdPort}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto http;
          client_max_body_size 500m;
        '';

        recommendedProxySettings = false;
      };
    };
  };

  security.acme.certs."code.${domain}" = {
    group = "nginx";
    reloadServices = [ "nginx.service" ];
  };
}
