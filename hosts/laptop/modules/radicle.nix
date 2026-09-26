{
  pkgs,
  lib,
  keys,
  config,
  ...
}:
let
  seeds = {
    iris = "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@iris.radicle.network:58776";
    rosa = "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@rosa.radicle.network:58776";
    server = "z6MknUx5zFKTEEnWfaVwWHGE7GshBez84K3gKH6t2DHCCrmb@code.oabragh.dedyn.io:3007";
  };

  radicleConfig = {
    publicExplorer = "https://radicle.network/nodes/$host/$rid$path";

    preferredSeeds = [
      seeds.server
      seeds.iris
      seeds.rosa
    ];

    cli = {
      hints = true;
    };

    node = {
      alias = "oabragh";
      network = "main";
      log = "INFO";
      relay = "auto";
      workers = 8;

      peers = {
        type = "dynamic";
      };

      connect = [
        seeds.server
      ];

      seedingPolicy = {
        default = "block";
      };

      limits = {
        routingMaxSize = 1000;
        routingMaxAge = 604800;
        gossipMaxAge = 1209600;
        fetchConcurrency = 1;
        maxOpenFiles = 4096;
        fetchPackReceive = "500.0 MiB";
        fetchTimeout = 30;

        connection = {
          inbound = 128;
          outbound = 16;
        };

        rate = {
          inbound = {
            fillRate = 5.0;
            capacity = 1024;
          };
          outbound = {
            fillRate = 10.0;
            capacity = 2048;
          };
        };
      };
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    radicle-node
    radicle-desktop
  ];

  age.secrets.radicle = {
    file = ../../../secrets/laptop/radicle.age;
    owner = "oabragh";
    group = "users";
  };

  hjem.users.oabragh = {
    files.".radicle/config.json" = {
      generator = lib.generators.toJSON { };
      value = radicleConfig;
    };

    files.".radicle/keys/radicle".source = config.age.secrets.radicle.path;
    files.".radicle/keys/radicle.pub".text = keys.radicle.laptop-node;
  };
}
