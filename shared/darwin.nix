{
  pkgs,
  lib,
  inputs,
  host,
  ...
}:

{
  imports = [ ../darwin ];
  # This modifies /etc/shells file, take this later
  # environment.shells = [ pkgs.zsh ];

  system.primaryUser = host.user;

  # Window manager switch: "yabai" (yabai + skhd) or "aerospace".
  # This is the only line to change; see darwin/window-manager.nix. mkDefault so
  # a host can override it in systems/<host>/host.nix.
  my.windowManager.backend = lib.mkDefault "yabai";

  my.services = {
    sketchybar.enable = true;
    jankyborders.enable = true;
  };

  system.defaults = {
    dock = {
      mru-spaces = false;
      expose-group-apps = true;
      autohide = true;
      orientation = "left";
      tilesize = 56;
      showhidden = true;
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

    # Hand the three-finger horizontal swipe to BetterTouchTool, which drives
    # AeroSpace workspaces through `wm-workspace`. The four-finger swipe keeps
    # its macOS meaning, so Mission Control / full-screen apps still work.
    # 0 = off, 1 = swipe between pages, 2 = swipe between full-screen apps.
    #
    # This one option covers both trackpads: nix-darwin writes every
    # `system.defaults.trackpad.*` key to com.apple.AppleMultitouchTrackpad
    # (built-in) *and* com.apple.driver.AppleBluetoothMultitouch.trackpad
    # (Magic Trackpad), so listing the Bluetooth domain again by hand is
    # redundant.
    #
    # Caveat worth remembering: `defaults write` does not reach the multitouch
    # driver. The driver reads these keys when it initialises - at login, or
    # when a Bluetooth trackpad reconnects - so after `task update-osx` the
    # written plist and the driver's live state can disagree until the next
    # login. Verify what the driver actually has, not what the plist says:
    #
    #   ioreg -c AppleMultitouchDevice -r -d 1 | grep -o \
    #     '"TrackpadThreeFingerHorizSwipeGesture"=[0-9]'
    #
    # If that disagrees with this value, toggling System Settings > Trackpad >
    # More Gestures > "Swipe between pages" pushes it through without a logout.
    # A stale 2 here means macOS swallows the swipe and BTT never sees it.
    trackpad.TrackpadThreeFingerHorizSwipeGesture = 0;

    # These have no nix-darwin options of their own.
    CustomUserPreferences = {
      # Same trade on the Magic Mouse: its two-finger horizontal swipe goes to
      # AeroSpace rather than to macOS Spaces.
      "com.apple.AppleMultitouchMouse".MouseTwoFingerHorizSwipeGesture = 0;
      "com.apple.driver.AppleBluetoothMultitouch.mouse".MouseTwoFingerHorizSwipeGesture = 0;
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
    _HIHideMenuBar = true;
    AppleShowAllExtensions = true;
    ApplePressAndHoldEnabled = false;
    # Shortest delay before a held key starts repeating.
    InitialKeyRepeat = 15;

    # Enables using the function keys as the F<number> key instead of OS controls
    "com.apple.keyboard.fnState" = false;
  };
}
