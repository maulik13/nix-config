{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.windowManager;
  isYabai = cfg.backend == "yabai";
  isAerospace = cfg.backend == "aerospace";

  aerospaceBin = "${config.services.aerospace.package}/bin/aerospace";
  yabaiBin = "${config.services.yabai.package}/bin/yabai";

  # AeroSpace creates a workspace on demand for any name it is given, so a typo
  # in a gesture tool would silently succeed and strand you on a phantom
  # workspace. The valid names are known here, so reject anything else.
  knownWorkspaces = config.services.aerospace.settings.persistent-workspaces or [ ];
  knownWorkspacesList = lib.concatStringsSep " " knownWorkspaces;

  # A stable command for things that cannot read this Nix config - BetterTouchTool
  # gestures in particular, whose mapping lives in BTT's own database. Pointing
  # those at `wm-workspace next` instead of at a window manager directly means the
  # gesture keeps working after my.windowManager.backend is flipped, with no
  # re-editing on the BTT side.
  #
  # The branch is resolved at build time: switching backends produces a different
  # script rather than something that probes at runtime.
  wmWorkspaceBody =
    if isAerospace then
      ''
        # The first clause focuses whatever is visible on the monitor under the
        # pointer, so a gesture acts on the screen being pointed at rather than
        # wherever keyboard focus happens to sit.
        case "$1" in
        next)
          exec ${aerospaceBin} eval 'list-workspaces --monitor mouse --visible | workspace --stdin next; workspace next --wrap-around'
          ;;
        prev)
          exec ${aerospaceBin} eval 'list-workspaces --monitor mouse --visible | workspace --stdin next; workspace prev --wrap-around'
          ;;
        *)
          if [[ " ${knownWorkspacesList} " != *" $1 "* ]]; then
            echo "wm-workspace: unknown workspace '$1'" >&2
            echo "known: ${knownWorkspacesList}" >&2
            exit 2
          fi
          exec ${aerospaceBin} workspace "$1"
          ;;
        esac
      ''
    else
      ''
        # yabai has no --wrap-around, and --focus fails at either end of the
        # list, so wrapping is the fallback.
        case "$1" in
        next)
          ${yabaiBin} -m space --focus next 2>/dev/null || ${yabaiBin} -m space --focus first
          ;;
        prev)
          ${yabaiBin} -m space --focus prev 2>/dev/null || ${yabaiBin} -m space --focus last
          ;;
        *)
          exec ${yabaiBin} -m space --focus "$1"
          ;;
        esac
      '';

  wmWorkspace = pkgs.writeShellApplication {
    name = "wm-workspace";
    text = ''
      # Generated for my.windowManager.backend = "${cfg.backend}".
      if [ "$#" -ne 1 ]; then
        echo "usage: wm-workspace next|prev|<workspace>" >&2
        exit 2
      fi

      ${wmWorkspaceBody}
    '';
  };
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

        Whichever backend is selected, `wm-workspace next|prev|<workspace>` is
        installed as a stable entry point for gesture tools.
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

    environment.systemPackages = [ wmWorkspace ];
  };
}
