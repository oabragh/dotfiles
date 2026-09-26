{ config, ... }:
let
  domain = config.domain;
  stalwartMgmtPort = 8080;
  stalwartJmapPort = 3004;
  bulwarkPort = 3005;
in
{
  imports = [
    ./stalwart-module.nix
  ];

  age.secrets = {
    "stalwart-admin" = {
      file = ../../../../secrets/server/stalwart-admin.env.age;
      owner = "stalwart";
      group = "stalwart";
    };

    "bulwark-session" = {
      file = ../../../../secrets/server/bulwark-session.age;
      owner = "bulwark";
      group = "bulwark";
    };
  };

  services.stalwart = {
    enable = true;
    url = "http://127.0.0.1:${toString stalwartMgmtPort}";
    credentialsFile = config.age.secrets."stalwart-admin".path;

    dataStore = {
      "@type" = "PostgreSql";
      host = "127.0.0.1";
      port = 5432;
      database = "stalwart";
      authUsername = "stalwart";
      authSecret."@type" = "None";
    };

    plan = [
      {
        "@type" = "reconcile";
        object = "NetworkListener";
        matchOn = [ "name" ];
        value = {
          smtp = {
            name = "smtp";
            bind."[::]:25" = true;
            protocol = "smtp";
            useTls = true;
            tlsImplicit = false;
          };
          submissions = {
            name = "submissions";
            bind."[::]:465" = true;
            protocol = "smtp";
            useTls = true;
            tlsImplicit = true;
          };
          imaps = {
            name = "imaps";
            bind."[::]:993" = true;
            protocol = "imap";
            useTls = true;
            tlsImplicit = true;
          };
          mgmt = {
            name = "mgmt";
            bind."127.0.0.1:${toString stalwartMgmtPort}" = true;
            protocol = "http";
            useTls = false;
          };
          jmap = {
            name = "jmap";
            bind."127.0.0.1:${toString stalwartJmapPort}" = true;
            protocol = "http";
            useTls = false;
          };
        };
      }

      {
        "@type" = "upsert";
        object = "Certificate";
        matchOn = [ "subjectAlternativeNames" ];
        value.cert-main = {
          subjectAlternativeNames = "mail.${domain}";

          certificate = {
            "@type" = "File";
            filePath = "/var/lib/acme/mail.${domain}/fullchain.pem";
          };

          privateKey = {
            "@type" = "File";
            filePath = "/var/lib/acme/mail.${domain}/key.pem";
          };
        };
      }

      {
        "@type" = "upsert";
        object = "Domain";
        matchOn = [ "name" ];
        value.dom-main = {
          name = domain;
          aliases = { };

          certificateManagement = {
            "@type" = "Manual";
          };

          dkimManagement = {
            "@type" = "Automatic";
          };

          dnsManagement = {
            "@type" = "Manual";
          };

          subAddressing = {
            "@type" = "Enabled";
          };
        };
      }

      {
        "@type" = "update";
        object = "SystemSettings";
        value = {
          defaultDomainId = "#dom-main";
          defaultHostname = "mail.${domain}";
          defaultCertificateId = "#cert-main";
        };
      }

      {
        "@type" = "update";
        object = "Http";
        value = {
          useXForwarded = true;
          usePermissiveCors = false;
          responseHeaders = {
            "Access-Control-Allow-Origin" = "https://mail.${domain}";
            "Access-Control-Allow-Headers" = "Authorization, Content-Type, Accept, X-Requested-With";
            "Access-Control-Allow-Methods" = "POST, GET, PATCH, PUT, DELETE, HEAD, OPTIONS";
            "Access-Control-Allow-Credentials" = "true";
          };
        };
      }
    ];
  };

  services.bulwark = {
    enable = true;
    hostname = "127.0.0.1";
    port = bulwarkPort;

    settings = {
      jmapServerUrl = "https://jmap.${domain}";
      sessionSecretFile = config.age.secrets."bulwark-session".path;
      stalwartFeaturesEnabled = true;
      logLevel = "info";

      # branding = {
      #   appName = "Mail";
      # };

      policies = {
        features.sidebarAppsEnabled = false;
      };
    };

    telemetry.enabled = false;
    updateCheck.enabled = false;
  };

  services.nginx.virtualHosts = {
    "jmap.${domain}" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "mta-sts.${domain}"
        "autoconfig.${domain}"
        "autodiscover.${domain}"
      ];

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString stalwartJmapPort}";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 100m;
        '';
      };
    };

    "mail.${domain}" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [ domain ];

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString bulwarkPort}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto http;
        '';

        recommendedProxySettings = false;
      };
    };
  };

  users.users.stalwart.extraGroups = [ "nginx" ];

  security.acme.certs."mail.${domain}" = {
    group = "nginx";
    reloadServices = [ "stalwart.service" ];
  };
}
