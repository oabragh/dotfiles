{
  pkgs,
  ...
}:

let
  iconTheme = "Papirus-Dark";
  gtkTheme = "adw-gtk3-dark";
  cursorTheme = "Bibata-Modern-Classic";
  cursorSize = "24";
  fontName = "Noto Sans";
  fontSize = "11";

  gtkSettings = ''
    [Settings]
    gtk-theme-name=${gtkTheme}
    gtk-icon-theme-name=${iconTheme}
    gtk-cursor-theme-name=${cursorTheme}
    gtk-cursor-theme-size=${cursorSize}
    gtk-font-name=${fontName} ${fontSize}
  '';
in
{
  environment.systemPackages = with pkgs; [
    bibata-cursors
    papirus-icon-theme
    gnome-themes-extra
    adw-gtk3
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = cursorSize;
  };

  programs.dconf.enable = true;

  hjem.users.oabragh = {
    xdg.config.files = {
      "gtk-3.0/settings.ini".text = gtkSettings;
      "gtk-4.0/settings.ini".text = gtkSettings;
    };

    files = {
      ".icons/default/index.theme".text = ''
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=${cursorTheme}
      '';
    };
  };
}
