{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.sys;
in
{
  imports = [
    (inputs.hjem.nixosModules.default)
  ];

  users.users = lib.mapAttrs (name: userConfig: {
    isNormalUser = true;
    description = userConfig.description;
    packages = userConfig.packages;

    extraGroups =
      userConfig.extraGroups
      ++ lib.optionals (name == cfg.host.owner) [
        "wheel"
        "networkmanager"
      ]
      ++ lib.optionals (cfg.host.name == "machine") [
        "input"
      ];
  }) cfg.users;

  hjem.users = lib.mapAttrs (name: userConfig: {
    user = name;
    directory = "/home/${name}";
  }) cfg.users;

  # Override already existing files
  hjem.clobberByDefault = true;
}
