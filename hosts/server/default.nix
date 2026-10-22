{
  imports = [
    ./hardware-configuration.nix
    ./deployments
    ./modules
  ];

  services.qemuGuest.enable = true;

  networking = {
    hostName = "server";

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  domain = "oabragh.com";

  system.stateVersion = "26.05";
}
