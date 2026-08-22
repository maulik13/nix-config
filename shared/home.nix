{
  inputs,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:
let
  # argonaut's flake does not build under Nix as shipped: two of its tests fail
  # in the sandbox, on both v2.19.0 and the default branch. Upstream CI runs
  # only CodeQL - no Go test job - so nothing catches it there.
  #
  #   TestRollbackDiff_ComparesSelectedAgainstCurrentRevision shells out to
  #     git, which the sandbox does not provide. Adding it is the real fix.
  #
  #   TestEventsCommand_Off_ClosesPaneAndStopsAutoOpen passes outside the
  #     sandbox under every variation tried, so it is sensitive to the sandbox
  #     rather than broken. Skipped, as upstream already skips two others.
  #
  # Appending to upstream's -skip rather than replacing it keeps their entries
  # if the pin moves; if they ever drop the flag the build fails loudly, which
  # is the right time to revisit. Both halves can go once upstream fixes this.
  argonaut =
    (inputs.argonaut.packages.${pkgs.stdenv.hostPlatform.system}.default).overrideAttrs
      (old: {
        nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [ pkgs.git ];
        checkFlags = map (
          f: if lib.hasPrefix "-skip=" f then "${f}|TestEventsCommand_Off_ClosesPaneAndStopsAutoOpen" else f
        ) (old.checkFlags or [ ]);
      });
in
{
  imports = [
    ../programs
    inputs.catppuccin.homeModules.catppuccin
    inputs.textfox.homeManagerModules.default
    inputs.hunk.homeManagerModules.default
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
    cloudflared
    # _1password-cli # To use beta we need to manually install
    stripe-cli

    # AI stuff (from llm-agents.nix)
    pkgs.llm-agents.opencode
    pkgs.llm-agents.ccusage
    pkgs.llm-agents.pi
    inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Programming
    uv
    nixfmt
    devbox
    podman
    nodejs_22
    pnpm
    cargo
    kcl
    go
    crystal

    # Ops
    kubectl
    kubernetes-helm
    kustomize
    kube-capacity
    helmfile
    crossplane-cli
    upbound
    fluxcd
    flux9s
    k9s
    kubectl-ktop
    ctop
    kubetui
    kubeswitch
    pkgs-stable.kubelogin
    kind
    argocd
    upcloud-cli

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
    argonaut
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

    mise = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      defaultOptions = [
        "--height 40%"
        "--border"
        "--cycle"
      ];
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      fileWidget.command = "fd --type f --follow --exclude .git";
      changeDirWidget.command = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      historyWidget.options = [
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
      shellWrapperName = "y";
    };

    hunk = {
      enable = true;
      enableGitIntegration = true;
    };
  };

  # Catppuccin magic
  catppuccin = {
    enable = true;
    autoEnable = false;
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

    # k9s rewrites its own config.yaml on every session, so backup-on-collision
    # breaks the second rebuild. Let HM forcibly own it instead.
    configFile."k9s/config.yaml".force = true;
  };
}
