{ config, keys, ... }:
let
  ports = config.modules.server.ports;
  radicleSeedDomain = "seed.${config.domain}";
  radicleSeedPort = ports.radicleSeed;
  radicleHttpdPort = ports.radicleHttpd;

  aliases = {
    dotfiles = "rad:z39hwsxW4pZF6VPtAvg1K2x3ZDqHu";
    iris = "rad:z2uS3fcaBfRS538FL5fLVk17UACws";
  };
in
{
  age.secrets.radicle = {
    file = "${self}/secrets/server/radicle.age";
    owner = "radicle";
    group = "radicle";
  };

  services.radicle = {
    enable = true;

    publicKey = keys.radicle.server-node;
    privateKey = config.age.secrets.radicle.path;

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
        alias = radicleSeedDomain;
        externalAddresses = [ "${radicleSeedDomain}:${toString radicleSeedPort}" ];
        seedingPolicy = {
          default = "block";
          scope = "all";
        };
      };
    };
  };

  services.nginx.virtualHosts = {
    "${radicleSeedDomain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString radicleHttpdPort}";
        proxyWebsockets = true;
      };

      locations."= /" = {
        return = "302 https://${config.domain}/repos";
      };
    };
  };
}
