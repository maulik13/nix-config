{
  config,
  lib,
  ...
}:
let
  cfg = config.my.windowManager;
  isYabai = cfg.backend == "yabai";
  isAerospace = cfg.backend == "aerospace";
in
{
  options.my.windowManager = {
    backend = lib.mkOption {
      type = lib.types.enum [
        "yabai"
        "aerospace"
      ];
      default = "yabai";
      example = "aerospace";
      description = ''
        Which window manager to run. Exactly one is ever enabled.

        "yabai"     yabai + skhd on top of macOS Spaces. Requires the scripting
                    addition and partially disabled SIP. Space create/destroy is
                    broken on macOS 26.x, so labelled Spaces disappear on undock.

        "aerospace" AeroSpace with its own built-in hotkey daemon. Virtual
                    workspaces that macOS cannot delete, and no SIP changes.
                    skhd is not started; its bindings live in darwin/aerospace.nix.

        Flip this in shared/darwin.nix (or override per host in
        systems/<host>/host.nix), then run `task update-osx`.
      '';
    };
  };

  config = {
    # Derived with mkDefault so an individual service can still be forced on by
    # hand - e.g. keeping skhd for hotkeys that have nothing to do with tiling.
    my.services = {
      yabai.enable = lib.mkDefault isYabai;
      skhd.enable = lib.mkDefault isYabai;
      aerospace.enable = lib.mkDefault isAerospace;
    };
  };
}
