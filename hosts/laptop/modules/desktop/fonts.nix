{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono # classic
      source-serif # goated font

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig = {
      hinting.style = "medium";
      subpixel.rgba = "rgb";
      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans Arabic"
        ];
        serif = [
          "Source Serif 4"
          "Noto Naskh Arabic"
        ];
        monospace = [
          "JetBrainsMonoNL NF"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };

}
