{
  inputs,
  ...
}:
let
  userName = "oabragh";
in
{
  imports = [
    (inputs.hjem.nixosModules.default)
  ];

  users.users.${userName} = {
    isNormalUser = true;
    description = "Omar Abragh";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  hjem.users.${userName} = {
    user = userName;
    directory = "/home/${userName}";
  };

  # Override already existing files
  hjem.clobberByDefault = true;
}
