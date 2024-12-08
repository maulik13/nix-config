{ config, lib, pkgs, ... }:

{
  # Fonts
  # https://search.nixos.org/options?channel=unstable&show=fonts
  fonts = {

    # Font Directory
    # https://search.nixos.org/options?channel=unstable&show=fonts.fontDir
    fontDir.enable = true;

    # Font Packages
    # https://search.nixos.org/options?channel=unstable&show=fonts.fonts
    fonts = with pkgs; [
      fira-code-symbols
      hack-font
      inconsolata
      inter
      iosevka
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      open-sans
      roboto
      roboto-mono
      source-sans
      source-serif
    ];
  };
}
