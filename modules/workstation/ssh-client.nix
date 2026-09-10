{ ... }: {
  programs.ssh = {
    knownHosts = {
      "vps" = {
        hostNames = [
          "vps"
          "159.195.112.189"
        ];
        publicKeyFile = ../../ssh-keys/vps.pub;
      };
    };

    extraConfig = ''
      Host vps
        Hostname 159.195.112.189
        User root
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
