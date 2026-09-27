{
  config,
  ...
}:

let
  matrixDomain = "matrix.${config.domain}";
  matrixServerPort = 3009;
in
{
  age.secrets."registration-token" = {
    file = ../../../../secrets/server/matrix-registration-token.age;
    owner = "tuwunel";
    group = "tuwunel";
  };

  nix.settings = {
    extra-substituters = [
      "https://cache.tuwunel.chat"
      "https://tuwunel.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.tuwunel.chat-1:ZafUaXiRMozDa9N2SWim6EdzH0EEjWjwfvlTxXvcjLA="
      "tuwunel.cachix.org-1:VRecUeDcaPxtYDA6bnMF3snPM7VYX8K605z4uuG2nWc="
    ];
  };

  networking.firewall.allowedTCPPorts = [ 8448 ];

  services.matrix-tuwunel = {
    enable = true;
    settings.global = {
      server_name = config.domain;
      address = [
        "127.0.0.1"
        "::1"
      ];
      port = [ matrixServerPort ];
      allow_federation = true;
      new_user_displayname_suffix = "";

      well_known = {
        client = "https://${matrixDomain}";
        server = "${matrixDomain}:443";
      };

      ip_source = "x_real_ip";

      allow_registration = true;
      registration_token_file = config.age.secrets."registration-token".path;
    };
  };

  services.nginx.virtualHosts = {
    "${config.domain}" = {
      # TODO: put this somewhere else when you host website
      enableACME = true;
      forceSSL = true;

      locations."^~ /.well-known/matrix/" = {
        proxyPass = "http://127.0.0.1:${toString matrixServerPort}";
        extraConfig = ''
          proxy_set_header Host ${matrixDomain};
        '';
      };
    };

    "${matrixDomain}" = {
      enableACME = true;
      forceSSL = true;

      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "0.0.0.0";
          port = 8448;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 443;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 8448;
          ssl = true;
        }
      ];

      extraConfig = ''
        client_max_body_size 100M;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString matrixServerPort}";
        proxyWebsockets = true;
      };
    };
  };
}
