{ config, ... }:
let
  cfg = config.sys;
  domain = cfg.domain;

  minifluxPort = 3002;
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

  services.nginx.virtualHosts."rss.${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:${toString minifluxPort}";
  };
}
