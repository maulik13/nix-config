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

  # To make this work, homebrew need to be installed manually, see
  # https://brew.sh The apps installed by homebrew are not managed by nix, and
  # not reproducible!  But on macOS, homebrew has a much larger selection of
  # apps than nixpkgs, especially for GUI apps!
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
    "pinentry-mac"
    "curl"
    # https://github.com/rgcr/m-cli
    "m-cli"
  ];

  homebrew.casks = [
    "keycastr"
    "homerow"
    "alfred"
    "bruno"
    "podman-desktop"
  ];

}
