{ config, keys, ... }:
let
  radicleSeedPort = 3007;
  radicleHttpdPort = 3008;

  aliases = {
    dotfiles = "rad:z39hwsxW4pZF6VPtAvg1K2x3ZDqHu";
  };
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
      inherit aliases;
    };

    settings = {
      node = {
        alias = "seed.${config.domain}";
        externalAddresses = [ "seed.${config.domain}:${toString radicleSeedPort}" ];
        seedingPolicy = {
          default = "block";
          scope = "all";
        };
      };
    };
  };

  services.nginx.virtualHosts = {
    "seed.${config.domain}" = {
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
        return = "302 https://${config.domain}/repos";
      };
    };
  };

  security.acme.certs."seed.${config.domain}" = {
    group = "nginx";
    reloadServices = [ "nginx.service" ];
  };
}
