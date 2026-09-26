{
  imports = [
    ./git
    ./mail
    ./radicle
    ./rss
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "oabragh@outlook.com";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    clientMaxBodySize = "512m";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
