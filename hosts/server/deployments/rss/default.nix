{ config, ... }:
let
  domain = config.domain;

  minifluxPort = 3002;
in
{
  age.secrets."miniflux-admin" = {
    file = ../../../../secrets/server/miniflux-admin.age;
    owner = "miniflux";
    group = "miniflux";
  };

  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = config.age.secrets."miniflux-admin".path;

    config = {
      LISTEN_ADDR = "127.0.0.1:${toString minifluxPort}";
      BASE_URL = "https://rss.${domain}/";
      RUN_MIGRATIONS = 1;
      BATCH_SIZE = "100";
    };
  };

  services.nginx.virtualHosts."rss.${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:${toString minifluxPort}";
  };
}
