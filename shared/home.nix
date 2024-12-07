{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../programs
    ../modules/home
  ];

  # The homeDirectory is configured by each host's configuration because it's
  # not constant between linux and macos
  home.username = "maulik";

  home.packages = with pkgs; [
    # Tooling 
    jq
    yazi
    kcl

    # Programming
    vim
    neovim
    nodejs
    cargo

    # Other stuff
    asciinema
    nix-output-monitor
  ];

  # Enables the programs and uses my configuration for them.
  # The options are defined in /programs/*
  my.programs = {
    zsh.enable = true;
    git.enable = true;
    tmux.enable = true;
  };

  # Enables programs that I don't have a more complicated config for.
  # Programs in this section should be limited to a few lines of config at most.
  programs = {
    home-manager.enable = true;

    broot = {
      enable = true;
      settings = {
        imports = [ "skins/dark-gruvbox.hjson" ];
        enable_kitty_keyboard = lib.mkForce true;
      };
    };

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
        # "--height ~40%"
      ];
    };

    gh = {
      enable = true;

      # Required because of a settings migration
      settings.version = 1;
    };

    bat = {
      enable = true;
      config.theme = "gruvbox-dark";
    };

    lazygit.enable = true;
  };
}
