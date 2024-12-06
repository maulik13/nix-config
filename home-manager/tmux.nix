{pkgs, lib, ...}:
{
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
}
