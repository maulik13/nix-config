{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../programs
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.username = "maulik";

  home.packages = with pkgs; [
    # Tooling
    ripgrep
    yazi
    _1password-cli
    fd

    # Terminal
    starship

    # Programming
    vim
    nodejs_22
    cargo
    nixfmt-rfc-style
    kcl
    kubeswitch
    k9s
    upbound
    crossplane-cli

    # Other stuff
    asciinema
    asciiquarium
    sl
    peaclock
    nix-output-monitor
  ];

  # Enables the programs and uses my configuration for them.
  # The options are defined in /programs/*
  my.programs = {
    zsh.enable = true;
    starship.enable = true;
    git.enable = true;
    tmux.enable = true;
    neovim.enable = true;
  };

  # Enables programs that I don't have a more complicated config for.
  # Programs in this section should be limited to a few lines of config at most.
  programs = {
    home-manager.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
      config.global = {
        load_dotenv = true;
        strict_env = true;
        warn_timeout = 0;
      };
    };

    zoxide = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    gh = {
      enable = true;
      # Required because of a settings migration
      settings.version = 1;
    };

    bat = {
      enable = true;
      catppuccin.enable = true;
    };

    lazygit = {
      enable = true;
      catppuccin = {
        enable = true;
        accent = "peach";
      };
    };

    k9s = {
      enable = true;
      catppuccin = {
        enable = true;
        transparent = true;
      };
    };

    yazi = {
      enable = true;
      catppuccin = {
        enable = true;
      };
    };

  };

  # lib.mkIf pkgs.stdenvNoCC.isDarwin
  xdg = {
    enable = true;

    configFile."peaclock" = {
      source = ./../config/peaclock/config;
      target = "peaclock/config";
    };

    configFile."diaball/fns.sh" = {
      source = ./../config/diaball/fns.sh;
    };
  };

  # Catppuccin magic
  catppuccin = {
    flavor = "macchiato";
  };

  home.shellAliases = {
    smerge = "/Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge";

    # k8s
    kgdsec = "kubectl get secret $1 -o go-template='{{range $k,$v := .data}}{{printf \"%s: \" $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{\"\n\"}}{{end}}'";
    kctx = "switch";
    kns = "switch ns";

    awsp = "export AWS_PROFILE=$(sed -n \"s/\[profile \(.*\)\]/\1/gp\" ~/.aws/config | fzf)";

    azswitch = "az account list | jq -r '.[] | [.id, .name] | @tsv' | fzf | cut -d$'\t' -f1 | xargs -I{} az account set --subscription {}";

    # Node development
    p = "pnpm";
    zj = "zellij -l welcome";
    pclock = "LC_ALL=C peaclock --config-dir ~/.config/peaclock";
    cd = "z";
    lgit = "lazygit --use-config-file=\"$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/macchiato/peach.yml\"";

  };
}
