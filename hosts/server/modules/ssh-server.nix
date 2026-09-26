{ keys, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      PrintLastLog = false;

      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;

      # Env variable is provided by my terminals
      # in order to dynamically choose a starship prompt
      AcceptEnv = [
        "SUPPORTS_IRIS_PALETTE"
      ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = keys.laptopOnly;

  networking.firewall.allowedTCPPorts = [ 22 ];
}
