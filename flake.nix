{
  #   _   _ _         ____             __ _
  #  | \ | (_)_  __  / ___|___  _ __  / _(_) __ _ ___
  #  |  \| | \ \/ / | |   / _ \| '_ \| |_| |/ _` / __|
  #  | |\  | |>  <  | |__| (_) | | | |  _| | (_| \__ \
  # |_| \_|_/_/\_\  \____\___/|_| |_|_| |_|\__, |___/
  #                                      |___/
  description = "Diaballin dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    # flake-registry.url = "github:NixOS/flake-registry";
    dooit.url = "github:dooit-org/dooit";
    dooit-extras.url = "github:dooit-org/dooit-extras";

    # nix-homebrew allows you to configure homebrew declaratively, so the taps
    # can be managed by nix as well. Keeps all versions predictable!
    homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  # In this context, outputs are mostly about getting home-manager what it
  # needs since it will be the one using the flake
  outputs = {
    nixpkgs,
    darwin,
    home-manager,
    ...
    } @ inputs: let
    darwinSystem = {user, arch ? "aarch64-darwin"}:
      darwin.lib.darwinSystem {
        system = arch;
        modules = [
          ./darwin/darwin.nix
          home-manager.darwinModules.home-manager 
          {
            _module.args = { inherit inputs; };
            home-manager = {
              users.${user} = import ./home-manager;
            };
            users.users.${user}.home = "/Users/${user}";
            nix.settings.trusted-users = [ user ];
          }
      ];
      };
    in

    {
    darwinConfigurations = {
      "mk-stacc-mac" = darwinSystem {
          user = "maulik";
      };
    };
  };
}
