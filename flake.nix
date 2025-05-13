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

    catppuccin.url = "github:catppuccin/nix";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    felixkratz-formulae = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };
    kcl-lang = {
      url = "github:kcl-lang/homebrew-tap";
      flake = false;
    };
    textfox.url = "github:adriankarlen/textfox";
    dooit.url = "github:dooit-org/dooit";
    dooit-extras.url = "github:dooit-org/dooit-extras";
    zjstatus = {
      url = "github:dj95/zjstatus";
    };
    nur.url = "github:nix-community/nur";
  };

  # In this context, outputs are mostly about getting home-manager what it
  # needs since it will be the one using the flake
  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      flake-utils,
      catppuccin,
      nix-homebrew,
      zjstatus,
      nur,
      ...
    }@inputs:
    let
      hosts = import ./config/hosts.nix;
      baseOverlays = [
        (final: prev: {
          zjstatus = zjstatus.packages.${prev.system}.default;
        })
        nur.overlays.default
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      home-manager-user =
        {
          user,
          path,
        }:
        {
          home-manager = {
            backupFileExtension = "bu";
            useUserPackages = true;
            useGlobalPkgs = true;
            users.${user} = import path;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        };
      mkDarwinConfig =
        host:
        let
          system = host.arch;
          pkgs = import nixpkgs {
            inherit system config;
            overlays = baseOverlays;
          };
        in
        darwin.lib.darwinSystem {
          inherit pkgs;
          inherit system;
          modules = [
            home-manager.darwinModules.home-manager
            (home-manager-user {
              user = host.user;
              path = ./systems/${host.dir}/home.nix;
            })
            ./systems/${host.dir}/host.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = host.user;
                # Optional: Declarative tap management
                taps = with inputs; {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "FelixKratz/homebrew-formulae" = felixkratz-formulae;
                  "kcl-lang/homebrew-tap" = kcl-lang;
                };
              };
            }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
    in
    {
      darwinConfigurations."${hosts.work.hostname}" = mkDarwinConfig hosts.work;
    };
}
