{ ... }:
{
  services.nginx.virtualHosts = {
    "${config.domain}" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [ "www.${config.domain}" ]
    };
  };
}
