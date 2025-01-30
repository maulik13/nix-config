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

    dooit.url = "github:dooit-org/dooit";
    dooit-extras.url = "github:dooit-org/dooit-extras";
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
            users.${user} = import path;
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
            home-manager.darwinModules.home-manager
            (home-manager-user {
              user = host.user;
              path = ./systems/${host.dir}/home.nix;
            })
            ./systems/${host.dir}/host.nix
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
