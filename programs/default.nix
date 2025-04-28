{ pkgs, lib, ... }:
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./kitty.nix
    ./tmux.nix
    ./zed.nix
    ./neovim.nix
    ./yabai.nix
    ./firefox.nix
  ];
}
