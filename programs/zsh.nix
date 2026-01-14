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
      dotDir = "${config.xdg.configHome}/zsh";
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

      initContent = ''
        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
          export PATH="$(brew --prefix)/opt/curl/bin:$PATH"
        fi
        export GOPATH=$HOME/go
        export PATH="$PATH:''${GOPATH}/bin:''${GOROOT}/bin"
        export PATH="$PATH:''$HOME/.npm-global/bin"

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

        DEVBOX_NO_PROMPT=0
        export PATH="''$HOME/.local/share/../bin:$PATH"
      '';

      shellAliases = {
        tf = "terraform";
        cld = "claude";
        p = "pnpm";
        pclock = "LC_ALL=C peaclock --config-dir ~/.config/peaclock";
        c = "z";
        smerge = "/Applications/Sublime\\ Merge.app/Contents/SharedSupport/bin/smerge";

        # k8s
        kgdsec = "kubectl get secret $1 -o go-template='{{range $k,$v := .data}}{{printf \"%s: \" $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{\"\n\"}}{{end}}'";
        kctx = "switch";
        kns = "switch ns";

        awsp = "export AWS_PROFILE=$(sed -n 's/^\\[profile \\(.*\\)\\]/\\1/p' ~/.aws/config | fzf)";
        azswitch = "az account list | jq -r '.[] | [.id, .name] | @tsv' | fzf | cut -d$'\t' -f1 | xargs -I{} az account set --subscription {}";

      };
      # Enable / disbale profiling
      zprof.enable = false;
    };
  };
}
