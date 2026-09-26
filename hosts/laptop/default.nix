{ inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules
    (inputs.nixos-hardware.nixosModules.hp-elitebook-830g6)
  ];

  networking.hostName = "laptop";

  system.stateVersion = "26.05";
}
