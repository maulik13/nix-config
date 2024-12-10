{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.programs.zsh;
in
{
  options.my.programs.zsh = {
    enable = mkEnableOption "My zsh configuration";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "kubectl"
          "docker"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
          "zsh-completions"
        ];
      };

      initExtra = ''
        export GOPATH=$HOME/go
        export GOROOT="$(brew --prefix golang)/libexec"
        export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
      '';
    };
  };
}
