{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  sys = {
    host = {
      name = "vps";
      platform = "x86_64-linux";
      owner = "oabragh";
    };

    git = {
      userName = "Omar Abragh";
      userEmail = "oabragh@outlook.com";
    };

    users = {
      "oabragh" = {
        description = "Omar";
        packages = with pkgs; [
          cowsay
        ];
        extraGroups = [ ];
      };
    };

    domain = "oabragh.dedyn.io";
  };

  services.qemuGuest.enable = true;

  system.stateVersion = "26.05";
}
