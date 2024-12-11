{ pkgs, lib, ... }:
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./git.nix
    # ./kitty
    ./tmux.nix
    ./zed.nix
  ];
  # lib.mkIf pkgs.stdenvNoCC.isDarwin
  home = {
    file = {
      peaclock = {
        source = ./../config/peaclock/config;
        target = ".config/peaclock/config";
      };
    };
  };
}
