{
  imports = [
    ./git.nix
    ./nix.nix
    ./options.nix
    ./packages.nix
    ./security.nix
    ./shell.nix
    ./users.nix
    ./bootloader.nix
    ./network.nix
  ];

  time.timeZone = "Africa/Casablanca";
  i18n.defaultLocale = "en_US.UTF-8";
}
