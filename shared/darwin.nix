{ pkgs, inputs, ... }:

{
  imports = [ ../darwin ];
  # This modifies /etc/shells file, take this later
  # environment.shells = [ pkgs.zsh ];
  #

  my.services = {
    yabai.enable = true;
    skhd.enable = true;
    sketchybar.enable = true;
  };

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "left";
      tilesize = 56;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      CreateDesktop = false;
      # This magic string makes it search the current folder by default
      FXDefaultSearchScope = "SCcf";

      # Use the column view by default-- the obviously correct and best view
      FXPreferredViewStyle = "clmv";
    };
  };
  security = {
    pam.services.sudo_local.touchIdAuth = true;
  };

  system.defaults.CustomUserPreferences = {
    NSGlobalDomain = {
      NSWindowShouldDragOnGesture = true;
    };
    "com.superultra.homerow" = {
      label-characters = "arstneiowfpluy";
      scroll-keys = "mnei";
      map-arrow-keys-to-scroll = false;
      launch-at-login = true;
      is-experimental-support-enabled = true;
      # The shortcut really is stored as the shift symbol and command symbol!
      non-search-shortcut = "⇧⌘Space";
    };
  };

  system.defaults.NSGlobalDomain = {
    # Automatic dark mode at night
    AppleInterfaceStyleSwitchesAutomatically = true;
    AppleShowAllExtensions = true;
    ApplePressAndHoldEnabled = false;

    # Enables using the function keys as the F<number> key instead of OS controls
    "com.apple.keyboard.fnState" = false;
  };
}
