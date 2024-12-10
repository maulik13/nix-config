{ pkgs, lib, ... }:
{
  imports = [
    ./zsh.nix
    ./git.nix
    # ./kitty
    ./tmux.nix
    ./zed.nix
  ];
  home = {
    file = {
      peaclock = lib.mkIf pkgs.stdenvNoCC.isDarwin {
        source = ./../config/peaclock/config;
        target = ".config/peaclock/config";
      };
    };
  };
}
