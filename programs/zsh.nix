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
      sessionVariables = {
        EDITOR = "nvim";
      };
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "kubectl"
        ];
      };

      initExtra = ''
        export GOPATH=$HOME/go
        export GOROOT="$(brew --prefix golang)/libexec"
        export PATH="$PATH:''${GOPATH}/bin:''${GOROOT}/bin"

        export PATH="''${KREW_ROOT:-''$HOME/.krew}/bin:$PATH"
        source <(switcher init zsh)
        [[ -f ~/.config/diaball/fns.sh ]] && source ~/.config/diaball/fns.sh
        [[ -f ~/.config/diaball/apikeys.sh.sh ]] && source ~/.config/diaball/apikeys.sh

        function add_newline_btw_prompts() {
          precmd() {
            echo
          }
        }

        # autoload -Uz add-zsh-hook
        add-zsh-hook precmd set_title_precmd
        add-zsh-hook precmd add_newline_btw_prompts
        add-zsh-hook preexec set_title_preexec
      '';

      shellAliases = {
        tf = "terraform";
      };
      # Enable / disbale profiling
      zprof.enable = false;
    };
  };
}
