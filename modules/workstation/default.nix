{ inputs, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
    ./packages.nix
    ./ssh-client.nix

    (inputs.nixos-hardware.nixosModules.hp-elitebook-830g6)
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-m17n
      fcitx5-gtk
    ];
  };

  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
}
