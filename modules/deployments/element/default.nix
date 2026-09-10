# TODO: fix ts

{ pkgs, lib, config, ... }: let
  domain = config.sys.domain;

  theme = builtins.fromJSON (builtins.readFile ./theme-everforest.json);

  conf = lib.recursiveUpdate theme {
    default_theme = "Everforest Dark";
    default_server_config = {
      "m.homeserver" = {
        base_url = "https://matrix.org";
        server_name = "matrix.org";
      };
    };
    disable_login_language_selector = true;
    disable_guests = true;
  };

  element = pkgs.element-web.override {
    inherit conf;
  };
in {
  services.nginx.virtualHosts."chat.${domain}" = {
    enableACME = true;
    forceSSL = true;
    root = element;
  };
}
