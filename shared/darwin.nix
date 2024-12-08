{ pkgs, ... }:

{
  system = {
    defaults = {
      # Dock
      dock.autohide = true;
      dock.orientation = "left";
      dock.tilesize = 36;
      # Finder
      finder.AppleShowAllExtensions = true;
      finder.ShowPathbar = true;
    };
  };
  security = {
    pam.enableSudoTouchIdAuth = true;
  };
}
