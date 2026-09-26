{ config, keys, ... }:
let
  domain = config.domain;

  radicleSeedPort = 3007;
  radicleHttpdPort = 3008;
in
{
  age.secrets.radicle = {
    file = ../../../../secrets/server/radicle.age;
    owner = "radicle";
    group = "radicle";
  };

  services.radicle = {
    enable = true;

    privateKey = config.age.secrets.radicle.path;
    publicKey = keys.radicle.server-node;

    node = {
      listenAddress = "[::]";
      listenPort = radicleSeedPort;
      openFirewall = true;
    };

    httpd = {
      enable = true;
      listenAddress = "127.0.0.1";
      listenPort = radicleHttpdPort;
      aliases = {
        dotfiles = "rad:z39hwsxW4pZF6VPtAvg1K2x3ZDqHu";
      };
    };

    settings = {
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
    # TODO: seed. or git. is a better fit
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

      locations."= /" = {
        return = "302 https://${domain}/repos";
      };
    };
  };

  security.acme.certs."code.${domain}" = {
    group = "nginx";
    reloadServices = [ "nginx.service" ];
  };
}
