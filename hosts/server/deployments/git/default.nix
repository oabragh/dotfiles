{ config, ... }:
let
  domain = config.domain;

  internalPort = 3001;
in
{
  services.postgresql.enable = true;

  services.forgejo = {
    enable = true;
    lfs.enable = true;

    database.type = "postgres";

    settings = {
      DEFAULT = {
        APP_NAME = "Git";
      };

      ui = {
        THEMES = "touch-grass-light,touch-grass-dark,everforest-dark,everforest-light,emerald-dark,amethyst-dark,topaz-dark";
        DEFAULT_THEME = "emerald-dark";
        DEFAULT_SHOW_FULL_NAME = true;
      };

      "ui.meta" = {
        AUTHOR = "Omar Abragh";
        DESCRIPTION = "Home to my Git repositories.";
        KEYWORDS = "git,oabragh,dotfiles,forgejo";
      };

      repository = {
        DEFAULT_PRIVATE = "private";
        PREFERRED_LICENSES = "GPL-3.0-only,GPL-3.0-or-later,MIT";
        DISABLE_STARS = true;
        DISABLE_FORKS = true;
        DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
      };

      server = {
        DOMAIN = "git.${domain}";
        SSH_DOMAIN = "git.${domain}";
        SSH_PORT = 22;
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = internalPort;
        ROOT_URL = "https://git.${domain}/";
        LANDING_PAGE = "explore";
      };

      service = {
        DISABLE_REGISTRATION = true;
      };

      "service.explore" = {
        DISABLE_USERS_PAGE = true;
        DISABLE_ORGANIZATIONS_PAGE = true;
      };

      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };

      pwa = {
        STANDALONE = true;
      };

      other = {
        SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
        SHOW_FOOTER_VERSION = false;
        SHOW_FOOTER_POWERED_BY = false;
      };
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d '${config.services.forgejo.customDir}' 0750 forgejo forgejo - -"
      "L+ '${config.services.forgejo.customDir}/templates' - - - - ${./custom}/templates"
      "L+ '${config.services.forgejo.customDir}/public' - - - - ${./custom}/public"
    ];

    services.forgejo.restartTriggers = [
      "${./custom}"
    ];
  };

  services.nginx.virtualHosts."git.${domain}" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString internalPort}";
      proxyWebsockets = true;
    };
  };
}
