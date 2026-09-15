{ inputs, host, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    user = host.user;
    autoMigrate = true;
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "jotta/homebrew-cli" = jotta-cli;
      "anomalyco/homebrew-tap" = opencode;
    };
    trust.taps = [
      "jotta/cli"
      "anomalyco/tap"
      "isen-ng/dotnet-sdk-versions"
      "romkatv/powerlevel10k"
    ];
  };

  # Homebrew itself is installed by nix-homebrew above, from its pinned
  # brew-src input -- there is no manual https://brew.sh step. The formulae and
  # casks it installs are still fetched at activation time and are not pinned by
  # the flake, so they are not reproducible. That trade is worth it on macOS,
  # where homebrew has a much larger selection of apps than nixpkgs, especially
  # GUI apps.
  homebrew = {
    enable = true;
  };

  homebrew.onActivation = {
    # Taps are provisioned and pinned by nix-homebrew, so updating them
    # imperatively during activation would conflict with their Nix-managed state.
    autoUpdate = false;
    upgrade = false;
  };

  homebrew.brews = [
    "curl"
    # https://github.com/rgcr/m-cli
    "m-cli"
  ];

  homebrew.casks = [
    # font-sketchybar-app-font is installed from nixpkgs via fonts.packages so
    # that the font and its icon map come from a single pinned derivation.
    "font-sf-mono"
    "ghostty"
    "keycastr"
    "homerow"
    "alfred"
    "bruno"
    "podman-desktop"
    # Gesture mapping for trackpad and Magic Mouse. Used to drive AeroSpace
    # workspace switching, which macOS cannot bind to a gesture itself.
    "bettertouchtool"
  ];

}
