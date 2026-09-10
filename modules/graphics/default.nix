{
  imports = [
    ./desktop.nix
    ./fonts.nix
    ./greeter.nix
    ./gtk.nix
    ./qt.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
