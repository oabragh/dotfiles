{ config, ... }:
let
  cfg = config.sys;
  domain = cfg.domain;

  excalidrawPort = 3004;
in
{
  virtualisation.oci-containers = {
    backend = "podman";
    containers.excalidraw = {
      image = "docker.io/excalidraw/excalidraw:latest";
      ports = [ "127.0.0.1:${toString excalidrawPort}:80" ];
      autoStart = true;
    };
  };

  services.nginx.virtualHosts = {
    "draw.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString excalidrawPort}";
        proxyWebsockets = true;
      };
    };
  };
}
