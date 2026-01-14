{
  inputs,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:
{
  imports = [
    ../programs
    inputs.catppuccin.homeModules.catppuccin
    inputs.textfox.homeManagerModules.default
  ];

  home.username = "maulik";

  home.packages = with pkgs; [
    # Tooling
    ripgrep
    yazi
    fd
    vim
    btop

    # Utils
    _1password-cli
    stripe-cli

    # Programming
    uv
    nixfmt-rfc-style
    devbox
    podman
    nodejs_22
    pnpm
    cargo
    upbound
    kcl
    go
    # kcl-language-server # Not available for macOS
    crossplane-cli

    # Ops
    kubectl
    kubernetes-helm
    kube-capacity
    helmfile
    k9s
    ktop
    ctop
    kubetui
    kubeswitch
    pkgs-stable.kubelogin
    kind
    argocd

    # Cloud
    pkgs-stable.azure-cli
    pkgs-stable.awscli2

    # Other stuff
    asciinema
    asciiquarium
    sl
    peaclock
    nix-output-monitor
    cmatrix
    inputs.argonaut.packages.${pkgs.system}.default
  ];

  # Enables the programs and uses my configuration for them.
  # The options are defined in /programs/*
  my.programs = {
    zsh.enable = true;
    starship.enable = true;
    git.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    firefox.enable = true;
    kitty.enable = true;
    zellij.enable = true;
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
      defaultOptions = [
        "--height 40%"
        "--border"
        "--cycle"
      ];
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      fileWidgetCommand = "fd --type f --follow --exclude .git";
      changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
    };

    gh = {
      enable = true;
      # Required because of a settings migration
      settings.version = 1;
    };

    bat = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    k9s = {
      enable = true;
    };

    yazi = {
      enable = true;
    };
  };

  # Catppuccin magic
  catppuccin = {
    bat.enable = true;
    flavor = "macchiato";
    lazygit = {
      enable = true;
      accent = "peach";
    };
    k9s = {
      enable = true;
      transparent = true;
    };
    yazi.enable = true;
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
}
