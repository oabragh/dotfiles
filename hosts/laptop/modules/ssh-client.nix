{ keys, ... }:
let
  server = {
    aliases = [
      "server"
      "vps"
    ];
    user = "root";
    ip = "159.195.112.189";
    pub = keys.hosts.server;
  };
in
{
  programs.ssh = {
    knownHosts = {
      "server" = {
        publicKey = server.pub;
        hostNames = server.aliases ++ [ server.ip ];
      };

      # ...
    };

    extraConfig = ''
      Host ${builtins.concatStringsSep " " server.aliases}
        Hostname ${server.ip}
        User ${server.user}
        IdentityFile ~/.ssh/id_ed25519
        ServerAliveInterval 60
        ServerAliveCountMax 3

      Host *
        SendEnv SUPPORTS_IRIS_PALETTE
        LogLevel QUIET
        AddKeysToAgent yes
        IdentitiesOnly yes
    '';
  };
}
