{ inputs, pkgs, ... }: {
  imports = [
    (inputs.qtengine.nixosModules.default)
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.breeze
    kdePackages.breeze-icons
  ];

  programs.qtengine = {
    enable = true;

    config = {
      theme = {
        colorScheme = "${pkgs.kdePackages.breeze}/colors/BreezeDark.colors";
        iconTheme = "breeze-dark";
        style = "breeze";

        font = {
          family = "Noto Sans";
          size = 11;
          weight = -1;
        };

        fontFixed = {
          family = "JetBrainsMonoNL NF";
          size = 11;
          weight = -1;
        };
      };

      misc = {
        singleClickActivate = true;
        menusHaveIcons = true;
        shortcutsForContextMenus = true;
      };
    };
  };

  qt.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qtengine";
    QT_QPA_PLATFORMTHEME_QT6 = "qtengine";
  };
}
