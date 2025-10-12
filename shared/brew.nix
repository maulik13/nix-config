{ pkgs, inputs, ... }:
{
  # To make this work, homebrew need to be installed manually, see
  # https://brew.sh The apps installed by homebrew are not managed by nix, and
  # not reproducible!  But on macOS, homebrew has a much larger selection of
  # apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;
  };

  homebrew.onActivation = {
    autoUpdate = true;
    upgrade = true;
  };

  homebrew.brews = [
    "borders"
    "pinentry-mac"
    "curl"
    "opencode"
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
