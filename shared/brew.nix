{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  environment.systemPath = [ "/opt/homebrew/bin" ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;

    user = "maulik";

    # All taps must be declared below.
    # TODO: Take over taps
    # mutableTaps = false;
    # taps = {
    #   "homebrew/homebrew-core" = inputs.homebrew-core;
    #   "homebrew/homebrew-cask" = inputs.homebrew-cask;
    #   "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    # };
    autoMigrate = true;
  };

  homebrew.enable = true;

  homebrew.brews = [
  ];

  homebrew.casks = [
    "keycastr"
    "homerow"
    "alfred"
  ];

}
