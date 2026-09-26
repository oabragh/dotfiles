{
  imports = [
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./shell.nix
    ./bootloader.nix
    ./network.nix
  ];

  time.timeZone = "Africa/Casablanca";
  i18n.defaultLocale = "en_US.UTF-8";
}
