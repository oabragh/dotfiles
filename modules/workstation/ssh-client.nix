{ ... }:
let
  vps = {
    aliases = [
      "vps"
      "server"
    ];
    user = "root";
    ip = "159.195.112.189";
    pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg5eLleDfGXoTz7nFhwXcnnA80dzSmLZGYc3vpnOuqJ";
  };
in
{
  programs.ssh = {
    knownHosts = {
      "vps" = {
        publicKey = vps.pub;
        hostNames = vps.aliases ++ [ vps.ip ];
      };

      # ...
    };

    extraConfig = ''
      Host ${builtins.concatStringsSep " " vps.aliases}
        Hostname ${vps.ip}
        User ${vps.user}
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
