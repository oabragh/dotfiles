{ config, self, ... }:
let
  minifluxPort = config.modules.server.ports.miniflux;
in
{
  age.secrets."miniflux-admin" = {
    file = "${self}/secrets/server/miniflux-admin.env.age";
  };

  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = config.age.secrets."miniflux-admin".path;

    config = {
      LISTEN_ADDR = "127.0.0.1:${toString minifluxPort}";
      BASE_URL = "https://rss.${config.domain}/";
      RUN_MIGRATIONS = 1;
      BATCH_SIZE = "100";
    };
  };

  services.nginx.virtualHosts."rss.${config.domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString minifluxPort}";
    };
  };
}
