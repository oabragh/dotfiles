{ lib, ... }:

let
  inherit (lib) mkOption types;

  userSubmodule = types.submodule {
    options = {
      description = mkOption {
        type = types.str;
        default = "";
      };
      packages = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

in
{
  options.sys = {
    host = {
      name = mkOption { type = types.str; };
      platform = mkOption {
        type = types.str;
        default = "x86_64-linux";
      };
      owner = mkOption {
        type = types.str;
      };
    };

    git = {
      userName = mkOption { type = types.str; };
      userEmail = mkOption { type = types.str; };
    };

    users = mkOption {
      type = types.attrsOf userSubmodule;
      default = { };
    };

    domain = mkOption {
      type = types.str;
      default = null;
    };
  };
}
