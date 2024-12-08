{
  pkgs,
  inputs,
  ...
}:
let
  language = _: t: t;
in
{
  imports = [
    ../../shared/host.nix
    ../../shared/darwin.nix
    ../../shared/brew.nix
  ];

  # This modifies /etc/shells file
  # environment.shells = [ pkgs.zsh ];

  users.users.maulik = {
    description = "Maulik";
    home = "/Users/maulik";
    shell = pkgs.zsh;
  };

  # This needs to be reapplied after system updates
  security.pam.enableSudoTouchIdAuth = true;

  networking.hostName = "mk-mac-work";

  # services.openssh.enable = true;
  nix.linux-builder = {
    enable = false;
    maxJobs = 8;
    package = pkgs.darwin.linux-builder-x86_64;
  };

  launchd.daemons.linux-builder = {
    serviceConfig = {
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
    };
  };

  system.stateVersion = 5;

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

    # Enables using the function keys as the F<number> key instead of OS controls
    "com.apple.keyboard.fnState" = true;
  };

  system.defaults.dock.autohide = true;

  system.defaults.finder = {
    # Shows a breadcrumb trail down the bottom of the Finder window
    ShowPathbar = true;

    # Hides desktop icons (but they're still accessible through Finder).
    # Because it never creates a desktop, you can't *click* on the desktop.
    CreateDesktop = false;

    # This magic string makes it search the current folder by default
    FXDefaultSearchScope = "SCcf";

    # Use the column view by default-- the obviously correct and best view
    FXPreferredViewStyle = "clmv";
  };
}
