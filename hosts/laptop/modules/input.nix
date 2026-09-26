{ pkgs, ... }:
{
  console.keyMap = "sv-latin1";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-m17n
      fcitx5-gtk
    ];
  };
}
