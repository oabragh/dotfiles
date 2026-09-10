{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.sys;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  sys = {
    host = {
      name = "machine";
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
          # TODO: move neovim somewhere else
          neovim
          neovide
          tree-sitter
          unzip

          sherlock
          nil
          nixd
          alejandra
          lua-language-server
          kdePackages.qtdeclarative
          rust-analyzer
        ];
        extraGroups = [ ];
      };

      # Example adding a new user

      # "guest" = {
      #   description = "Guest Account";
      #   packages = [ ];
      # };
    };
  };

  hjem.users = lib.mapAttrs (name: _: {
    files = {
      ".config/neovide/config.toml".source = (pkgs.formats.toml { }).generate "neovide-config" {
        title-hidden = true;
        maximized = true;
        frame = "none";
        tabs = false;
        srgb = true;

        font = {
          normal = "JetBrainsMono NF";
          size = 13;
          features = {
            "JetBrainsMono NF" = [
              "+ss01"
              "+ss07"
              "+ss11"
              "+calt"
              "+ss09"
              "+ss02"
              "+ss14"
            ];
          };
        };
      };
    };

  }) cfg.users;

  console.keyMap = "sv-latin1";

  system.stateVersion = "26.05";
}
