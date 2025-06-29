{ pkgs, ... }:

{
  imports = [
    ./dooit.nix
    ./firefox.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./sketchybar.nix
    ./starship.nix
    ./tmux.nix
    ./yabai.nix
    ./zed.nix
    ./zellij.nix
    ./zsh.nix
  ];
}
