{ config, ... }:
let
  cfg = config.sys;
  domain = cfg.domain;

  minifluxPort = 3002;
  nextfluxPort = 3003;
in
{
  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = "/etc/miniflux-admin.env";

    config = {
      LISTEN_ADDR = "127.0.0.1:${toString minifluxPort}";
      BASE_URL = "https://rss.${domain}/";
      RUN_MIGRATIONS = 1;
      BATCH_SIZE = "100";
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers.nextflux = {
      image = "electh/nextflux:latest";
      ports = [ "127.0.0.1:${toString nextfluxPort}:3000" ];
      autoStart = true;
    };
  };

  services.nginx.virtualHosts = {
    "rss.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString minifluxPort}";
      };
    };

    "reader.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString nextfluxPort}";
        proxyWebsockets = true;
      };
    };
  };
}
