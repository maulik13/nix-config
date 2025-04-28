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
    ./firefox.nix
    ./yabai.nix
    ./sketchybar.nix
  ];
}
