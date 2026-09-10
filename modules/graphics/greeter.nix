{
  inputs,
  ...
}:
{
  imports = [
    # (inputs.qylock.nixosModules.default)
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Classic";
        CursorSize = 24;
      };
    };
  };

  # Beautiful
  # programs.qylock = {
  #   enable = true;
  #   theme = "forest";
  # };

  systemd.services.display-manager.environment = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };
}
