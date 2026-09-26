{
  imports = [
    ./hardware-configuration.nix
    ./deployments
    ./modules
  ];

  networking = {
    hostName = "server";

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  domain = "oabragh.dedyn.io";

  services.qemuGuest.enable = true;

  system.stateVersion = "26.05";
}
