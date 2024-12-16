{ pkgs, inputs, ... }:
{
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew.enable = true;

  homebrew.brews = [
    "borders"
  ];

  homebrew.casks = [
    "keycastr"
    "homerow"
    "alfred"
  ];

}
