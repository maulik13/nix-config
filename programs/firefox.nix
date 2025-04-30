{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.programs.firefox;
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  # Generate file for locked settings
  mkAutoconfigJs =
    prefs:
    lib.concatStrings (
      lib.mapAttrsToList (name: value: ''
        lockPref("${name}", ${builtins.toJSON value}); 
      '') prefs
    );
in
{
  options.my.programs.firefox = {
    enable = lib.mkEnableOption "My Firefox configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # ---- POLICIES ----
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      };
      profiles = {
        "tui-textfox" = {
          name = "tui-textfox";
          isDefault = true;
          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              vimium
              firefox-color
              onepassword-password-manager
              lastpass-password-manager
              stylus
              refined-github
              react-devtools
            ];
            settings = {
              "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
                force = true;
                settings = {
                  dbInChromeStorage = true; # required for Stylus
                };
              };

            };
          };
          settings = {
            "extensions.autoDisableScopes" = 0;
            "browser.search.widget.inNavBar" = true;
            "extensions.activeThemeID" = "{e66520c5-4a3d-4bed-8b36-03b68aca7dc1}";
            "browser.startup.homepage.startpage" = "previous-session";
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.newtabpage.pinned" = [
              {
                title = "NixOS";
                url = "https://nixos.org";
              }
            ];
            "extensions.pocket.enabled" = false;
            # "browser.uiCustomization.state" = builtins.toJSON {
            #   placements = {
            #     widget-overflow-fixed-list = [ ];
            #     unified-extensions-area = [ ];
            #     # Toolbar
            #     nav-bar = [
            #       "back-button"
            #       "forward-button"
            #       "_3c078156-979c-498b-8990-85f7987dd929_-browser-action"
            #       "vertical-spacer"
            #       "urlbar-container"
            #       "screenshot-button"
            #       "unified-extensions-button"
            #     ];
            #     toolbar-menubar = [
            #       "menubar-items"
            #     ];
            #   };
            # };
          };
        };
      };
    };
    textfox = {
      enable = true;
      useLegacyExtensions = false;
      profile = "tui-textfox";
      config = {
        displayWindowControls = true;
        displayNavButtons = true;
        displayUrlbarIcons = true;
        tabs = {
        };
        sidebery = {
        };
      };
    };
  };
}
