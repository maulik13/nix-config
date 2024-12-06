{ pkgs, ... }:

{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    home-manager
    vim
    cargo
    tmux
    yazi
    kcl
    # pkgs.taskwarrior3
    (writeShellScriptBin "taskw" "exec -a $0 ${taskwarrior3}/bin/task $@")
  ];

  # Necessary for using flakes on this system.
  nix = {
    package = pkgs.nix;
    settings = {
      "experimental-features" = [ "nix-command" "flakes" ];
    };
  };

  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;
    yabai.enable = true;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;  # default shell on catalina
  };

  homebrew = {
    enable = true;

    casks = [
      "keycastr"
    ];
  };

  fonts.packages = [
    pkgs.atkinson-hyperlegible
    pkgs.jetbrains-mono
  ];

  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "left";
      };
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
      };
    };
  };
  security.pam.enableSudoTouchIdAuth = true;
}
