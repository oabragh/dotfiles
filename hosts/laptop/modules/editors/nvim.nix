{ pkgs, lib, ... }:
let
  neovideConfig = {
    title-hidden = true;
    maximized = true;
    frame = "none";
    tabs = false;
    srgb = true;

    font = {
      normal = "JetBrainsMono NF";
      size = 14;
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
in
{
  users.users.oabragh.packages = with pkgs; [
    neovim
    neovide
    tree-sitter
    unzip
    nil
    nixd
    alejandra
    lua-language-server
    kdePackages.qtdeclarative
    rust-analyzer
  ];

  hjem.users.oabragh.files = {
    ".config/neovide/config.toml" = {
      generator = lib.generators.toJSON;
      value = neovideConfig;
    };
  };
}
