{ pkgs, lib, ... }:
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./git.nix
    # ./kitty
    ./tmux.nix
    ./zed.nix
    ./neovim.nix
  ];
}
