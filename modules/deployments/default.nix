{
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

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
