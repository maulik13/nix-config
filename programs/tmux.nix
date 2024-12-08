{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.my.programs.tmux;
  in
{
  options.my.programs.tmux = {
    enable = mkEnableOption "My tmux configuration";
  };

  config = mkIf cfg.enable {
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    prefix = "C-space";
    escapeTime = 10;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "kitty";

    extraConfig = lib.fileContents ../.config/tmux/tmux.conf;

    plugins = with pkgs.tmuxPlugins; [
      logging
      pain-control
      sessionist
      tmux-thumbs
      yank
    ];
  };
  };
}
