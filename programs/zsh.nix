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
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "kubectl"
          "docker"
        ];
      };

      initExtra = ''
        export GOPATH=$HOME/go
        export GOROOT="$(brew --prefix golang)/libexec"
        export PATH="$PATH:''${GOPATH}/bin:''${GOROOT}/bin"

        # Configure fd with FZF
        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

        _fzf_compgen_path() {
          fd --hidden --exclude .git . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
          fd --type=d --hidden --exclude .git . "$1"
        }

        source <(switcher init zsh)
        [[ -f ~/.config/diaball/fns.sh ]] && source ~/.config/diaball/fns.sh

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
    };
  };
}
