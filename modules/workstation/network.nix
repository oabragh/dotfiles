{
  pkgs,
  ...
}:
{
  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    firewall.allowedTCPPorts = [
      3000 # Nextjs dev server
      6006 # Storybook dev server
    ];

    networkmanager = {
      wifi = {
        macAddress = "random";
        backend = "iwd";
      };

      dns = "none";
      ethernet.macAddress = "random";

      settings = {
        connection = {
          "ipv4.dhcp-send-hostname" = false;
          "ipv6.dhcp-send-hostname" = false;
        };
      };
    };

    nftables.enable = true;
  };

  services = {
    resolved.enable = false;

    stubby = {
      enable = true;
      settings = pkgs.stubby.passthru.settingsExample // {
        # Blocking that stuff
        upstream_recursive_servers = [
          {
            address_data = "1.1.1.3";
            tls_auth_name = "family.cloudflare-dns.com";
          }
          {
            address_data = "1.0.0.3";
            tls_auth_name = "family.cloudflare-dns.com";
          }
          {
            address_data = "2606:4700:4700::1113";
            tls_auth_name = "family.cloudflare-dns.com";
          }
          {
            address_data = "2606:4700:4700::1003";
            tls_auth_name = "family.cloudflare-dns.com";
          }
        ];
      };
    };
  };

}
