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
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dooit.url = "github:dooit-org/dooit";
    dooit-extras.url = "github:dooit-org/dooit-extras";

    # nix-homebrew allows you to configure homebrew declaratively, so the taps
    # can be managed by nix as well. Keeps all versions predictable!
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  # In this context, outputs are mostly about getting home-manager what it
  # needs since it will be the one using the flake
  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      nix-homebrew,
      flake-utils,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      ...
    }@inputs:
    let
      hosts = import ./config/hosts.nix;
      home-manager-user =
        { user, path }:
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            users.${user} = path;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        };
      mkDarwinConfig =
        host:
        darwin.lib.darwinSystem {
          system = host.arch;
          modules = [
            home-manager.nixosModules.home-manager
            (home-manager-user {
              user = host.user;
              path = ./systems/${host.dir}/home.nix;
            })
            ./systems/${host.dir}/host.nix
          ];
        };
    in
    {
      # darwinConfigurations = {
      #   mk-mac-work = darwin.lib.darwinSystem {
      #     system = "aarch64-darwin";
      #     modules = [
      #       home-manager.darwinModules.default
      #       (home-manager-user {
      #         user = "maulik";
      #         path = ./systems/macwork/home.nix;
      #       })
      #       ./systems/macwork/host.nix
      #     ];
      #     specialArgs = {
      #       inherit inputs;
      #     };
      #   };
      # };
      darwinConfigurations."${hosts.work.hostname}" = mkDarwinConfig hosts.work;
    };
}
