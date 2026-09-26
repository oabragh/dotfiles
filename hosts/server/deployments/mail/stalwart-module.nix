# thanks to @kosslan

{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkOption
    mkIf
    types
    concatMapStringsSep
    ;

  cfg = config.services.stalwart;

  configFile = pkgs.writeText "stalwart-datastore.json" (builtins.toJSON cfg.dataStore);

  reloadAction = {
    "@type" = "create";
    object = "Action";
    value.reload."@type" = "ReloadSettings";
  };

  planFile = pkgs.writeText "stalwart-plan.ndjson" (
    concatMapStringsSep "\n" (op: builtins.toJSON op) (cfg.plan ++ [ reloadAction ])
  );
in
{
  disabledModules = [ "services/mail/stalwart.nix" ];

  options.services.stalwart = {
    enable = mkEnableOption "Stalwart Mail Server (v0.16+)";

    package = mkOption {
      type = types.package;
      default = pkgs.stalwart_0_16;
      description = "Stalwart mail package.";
    };

    cliPackage = mkOption {
      type = types.package;
      default = pkgs.stalwart-cli;
      description = "Stalwart CLI management package.";
    };

    url = mkOption {
      type = types.str;
      description = "Internal management HTTP endpoint.";
    };

    credentialsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "EnvironmentFile containing STALWART_USER and STALWART_PASSWORD.";
    };

    dataStore = mkOption {
      type = types.attrs;
      description = "The DataStore object, serialized to the JSON config file the server bootstraps from.";
    };

    plan = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "List of stalwart-cli apply operations, reconciled into the running server on rebuild and followed by a settings reload.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically open standard mail ports in firewall.";
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.stalwart = {
        isSystemUser = true;
        group = "stalwart";
      };
      groups.stalwart = { };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      25
      465
      993
    ];

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "stalwart" ];
      ensureUsers = [
        {
          name = "stalwart";
          ensureDBOwnership = true;
        }
      ];
      authentication = ''
        host stalwart stalwart 127.0.0.1/32 trust
        host stalwart stalwart ::1/128 trust
      '';
    };

    systemd.services.stalwart = {
      description = "Stalwart Mail Server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "postgresql.target"
      ];
      requires = [ "postgresql.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/stalwart --config=${configFile}";
        EnvironmentFile = mkIf (cfg.credentialsFile != null) cfg.credentialsFile;
        User = "stalwart";
        Group = "stalwart";
        StateDirectory = "stalwart";
        CacheDirectory = "stalwart";
        Restart = "always";
        RestartSec = 5;
        LimitNOFILE = 65536;

        KillMode = "process";
        KillSignal = "SIGINT";
        UMask = "0077";

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
      };
    };

    systemd.services.stalwart-bootstrap = mkIf (cfg.plan != [ ]) {
      description = "Stalwart Configuration Bootstrap";
      wantedBy = [ "multi-user.target" ];
      after = [ "stalwart.service" ];
      wants = [ "stalwart.service" ];
      restartTriggers = [ planFile ];

      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        RestartSec = 2;
        Environment = "STALWART_URL=${cfg.url}";
        EnvironmentFile = mkIf (cfg.credentialsFile != null) cfg.credentialsFile;
        ExecStartPre = "${getExe pkgs.curl} --silent --fail --output /dev/null --retry 30 --retry-delay 1 --retry-all-errors ${cfg.url}/";
        ExecStart = "${cfg.cliPackage}/bin/stalwart-cli apply --file ${planFile} --quiet";
        RemainAfterExit = true;
      };
    };
  };
}
