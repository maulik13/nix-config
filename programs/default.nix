{ pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./ghostty.nix
    ./git.nix
    ./gpg.nix
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
