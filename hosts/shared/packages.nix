{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    btop
    dust
    eza
    fd
    fzf
    jq
    ripgrep
    sd
    wget
    git
    socat
    pfetch

    # TODO: make a shared neovim config for both vps and laptop
    neovim
  ];
}
