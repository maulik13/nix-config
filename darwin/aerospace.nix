{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.aerospace;

  # Same six workspaces the yabai setup labelled, in the same order. Unlike
  # macOS Spaces these are virtual: they always exist, so nothing has to create
  # or relabel them and macOS cannot delete them when a display is unplugged.
  workspaces = [
    "code1"
    "code2"
    "browse1"
    "browse2"
    "comm"
    "misc"
  ];

  # Workspaces 1-3 on the built-in display, 4-6 on the external one. When only
  # one display is connected AeroSpace falls back to it, so undocking is a no-op.
  onDisplay1 = [
    "code1"
    "code2"
    "browse1"
  ];

  monitorAssignment = lib.listToAttrs (
    map (ws: {
      name = ws;
      value = if lib.elem ws onDisplay1 then 1 else 2;
    }) workspaces
  );

  # ctrl + cmd + <n> focuses the nth workspace, matching the old skhd bindings.
  workspaceBindings = lib.listToAttrs (
    lib.imap1 (i: ws: {
      name = "ctrl-cmd-${toString i}";
      value = "workspace ${ws}";
    }) workspaces
  );

  # Apps that were manage=off in rules.sh: floated, and pinned to a workspace
  # where the yabai rule named one.
  floatOn = ws: pattern: {
    "if".app-name-regex-substring = pattern;
    run = [
      "layout floating"
      "move-node-to-workspace ${ws}"
    ];
  };

  # manage=off with no space assignment - float wherever it opens.
  floatOnly = pattern: {
    "if".app-name-regex-substring = pattern;
    run = "layout floating";
  };

  tileOn = ws: pattern: {
    "if".app-name-regex-substring = pattern;
    run = "move-node-to-workspace ${ws}";
  };
in
{
  options.my.services.aerospace = {
    enable = lib.mkEnableOption "My AeroSpace configuration";
  };

  config = lib.mkIf cfg.enable {
    services.aerospace = {
      enable = true;

      settings = {
        # Required for persistent-workspaces.
        config-version = 2;

        # launchd owns the lifecycle; the module asserts both of these.
        start-at-login = false;

        # The config lives in the nix store, so there is nothing to watch for
        # changes. Reload explicitly with ctrl+alt+shift+r or `task update-osx`.
        auto-reload-config = false;

        # Mirrors yabai's `layout bsp` / `split_ratio 0.50`.
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        accordion-padding = 30;

        # yabai had mouse_follows_focus off and focus_follows_mouse off.
        on-focused-monitor-changed = [ ];
        focus-follows-mouse.enabled = false;

        persistent-workspaces = workspaces;
        workspace-to-monitor-force-assignment = monitorAssignment;

        # yabai: window_gap 16 and padding 12 on every side. The top also has to
        # clear SketchyBar, which occupies 0-48px (height 44 + y_offset 4), so
        # 48 + 12 = 60.
        #
        # Unlike yabai, AeroSpace measures gaps from the screen's *visible*
        # frame, which already excludes a notch's safe area. The built-in
        # display reserves 32px that way, so a flat 60 would push its windows to
        # 92px and leave a visible gap under the bar. Subtract it there.
        gaps = {
          inner.horizontal = 16;
          inner.vertical = 16;
          outer.top = [
            { monitor."Built-in.*Display" = 28; }
            60
          ];
          outer.bottom = 12;
          outer.left = 12;
          outer.right = 12;
        };

        after-startup-command = [
          # browse2 was `--layout stack` under yabai; accordion is the analogue.
          "layout --workspace browse2 --root h_accordion"
        ];

        # Drives the bar's workspace indicator. The event is registered by
        # sketchybar-wm/aerospace/items/spaces.sh.
        #
        # Absolute path on purpose: AeroSpace's launchd agent carries no
        # EnvironmentVariables, so exec-* commands run with no PATH at all
        # (confirm with `aerospace list-exec-env-vars`) and a bare "sketchybar"
        # is not found. No `|| true` either - a silent failure here just leaves
        # the bar showing a stale workspace.
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "${config.services.sketchybar.package}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
        ];

        # ---- Window rules, in the order rules.sh added them ----------------
        # Order is significant: matching stops at the first hit unless
        # check-further-callbacks is set, which is how the two Chrome rules
        # reproduce yabai's title= / title!= pair.
        on-window-detected = [
          (tileOn "code1" "^kitty$")

          (tileOn "code2" "^Code$")
          (tileOn "code2" "^Claude")
          (tileOn "code2" "^pgAdmin 4$")
          (tileOn "code2" "^Postman$")

          # Work profile window first, everything else in Chrome after it.
          {
            "if" = {
              app-name-regex-substring = "^Google Chrome$";
              window-title-regex-substring = "Maulik$";
            };
            run = "move-node-to-workspace browse1";
          }
          (tileOn "browse1" "^Notion$")
          (tileOn "browse1" "draw.io")
          (tileOn "browse2" "^Google Chrome$")
          (tileOn "browse2" "^Firefox$")

          (tileOn "comm" "^Slack$")
          (tileOn "comm" "^Microsoft Outlook$")
          (tileOn "comm" "^Microsoft Teams$")

          (floatOn "misc" "^1Password$")
          (tileOn "misc" "^Music$")
          (floatOn "misc" "^Messages$")
          (floatOn "misc" "^WhatsApp$")
          (floatOn "misc" "^Telegram$")
          (floatOn "misc" "^FortiClient$")

          # Layout management exceptions
          (floatOnly "^System Settings$")
          (floatOnly "^System Preferences$")
          (floatOnly "^Calculator$")
          (floatOnly "^Dictionary$")
          (floatOnly "^App Store$")
          (floatOnly "^Activity Monitor$")
          (floatOnly "^Software Update$")
          (floatOnly "^Archive Utility$")
          (floatOnly "^Notes$")
          {
            "if".window-title-regex-substring = "About This Mac";
            run = "layout floating";
          }
        ];

        # ---- Keybindings, ported from darwin/skhd.nix ----------------------
        # Same chords as before. skhd's `meh` is shift+ctrl+alt, which is
        # written ctrl-alt-shift here.
        #
        # Not ported, because AeroSpace has no command for placing a floating
        # window at an absolute position or on a grid:
        #   shift+alt+a / d      left / right half
        #   shift+alt+c          centre in a 4x4 grid
        #   shift+alt+q/e/z/x    the four corners
        # Reach for Rectangle or Raycast if those turn out to matter. Note that
        # shift+alt+e was bound twice in skhd (corner grid and toggle split);
        # only toggle split survives.
        mode.main.binding = workspaceBindings // {
          # Focus window
          "ctrl-alt-h" = "focus left";
          "ctrl-alt-j" = "focus down";
          "ctrl-alt-k" = "focus up";
          "ctrl-alt-l" = "focus right";
          # Was stack.prev / stack.next; depth-first traversal is the analogue.
          "ctrl-alt-p" = "focus dfs-prev";
          "ctrl-alt-n" = "focus dfs-next";

          # Swap window
          "alt-shift-h" = "swap left";
          "alt-shift-j" = "swap down";
          "alt-shift-k" = "swap up";
          "alt-shift-l" = "swap right";

          # Move window (yabai --warp)
          "cmd-shift-h" = "move left";
          "cmd-shift-j" = "move down";
          "cmd-shift-k" = "move up";
          "cmd-shift-l" = "move right";

          # Balance window sizes
          "alt-shift-0" = "balance-sizes";

          # Closest survivor of the grid bindings: fill the screen
          "alt-shift-s" = "fullscreen";

          # Focus workspace: ctrl+cmd+1..6 come from workspaceBindings above.
          # ctrl+cmd+7..0 are dropped - there were only ever six Spaces.
          "ctrl-cmd-x" = "workspace-back-and-forth";

          # Focus monitor
          "ctrl-alt-z" = "focus-monitor prev";
          "ctrl-alt-c" = "focus-monitor next";
          "ctrl-alt-1" = "focus-monitor 1";
          "ctrl-alt-2" = "focus-monitor 2";
          "ctrl-alt-3" = "focus-monitor 3";

          # Send window to monitor and follow it
          "ctrl-alt-shift-p" = "move-node-to-monitor --focus-follows-window prev";
          "ctrl-alt-shift-n" = "move-node-to-monitor --focus-follows-window next";
          "ctrl-alt-shift-1" = "move-node-to-monitor --focus-follows-window 1";
          "ctrl-alt-shift-2" = "move-node-to-monitor --focus-follows-window 2";
          "ctrl-alt-shift-3" = "move-node-to-monitor --focus-follows-window 3";

          # Zoom. yabai's zoom-parent has no equivalent, so meh+d is unbound.
          "ctrl-alt-shift-space" = "fullscreen";

          # Toggle split orientation and float. AeroSpace rejects the 'split'
          # command while enable-normalization-flatten-containers is true, so
          # this toggles the focused container's orientation instead - the same
          # visible outcome as yabai's `window --toggle split`, and what
          # AeroSpace's own default config binds.
          "alt-shift-e" = "layout horizontal vertical";
          "alt-shift-space" = "layout floating tiling";

          # Layout toggles. Under yabai these changed the whole Space; in
          # AeroSpace floating is per window and tiles/accordion applies to the
          # focused container.
          "ctrl-alt-shift-f" = "layout floating tiling";
          "ctrl-alt-shift-c" = "layout tiles accordion";

          # Re-apply window rules to windows that are already open (yabai's
          # `rule --apply`).
          "ctrl-alt-shift-g" = "run-callback --for-every-window on-window-detected";

          # Reload config, then re-apply rules - what the old reload script did.
          "ctrl-alt-shift-r" = [
            "reload-config"
            "run-callback --for-every-window on-window-detected"
            "exec-and-forget osascript -e 'display notification \"Config reloaded\" with title \"AeroSpace\"'"
          ];

          # Window picker. Shows Alfred pre-filled with the keyword of the
          # AeroSpace Window Picker workflow, which lists every open window
          # across all workspaces and both monitors; picking one runs
          # `aerospace focus --window-id`. `search` is Alfred's AppleScript
          # command for "show yourself with this text already typed".
          #
          # Absolute path for the same reason as exec-on-workspace-change
          # above. exec-* actually runs with PATH=/opt/homebrew/{bin,sbin}:
          # /usr/{bin,sbin}:/bin:/sbin - not empty, but with no nix profile on
          # it (confirm with `aerospace list-exec-env-vars`).
          "ctrl-alt-shift-w" =
            "exec-and-forget /usr/bin/osascript -e 'tell application \"Alfred 5\" to search \"w \"'";

          # Bar controls
          "ctrl-alt-shift-b" = "exec-and-forget /usr/bin/pkill -9 sketchybar";
          "ctrl-alt-shift-m" = "exec-and-forget sketchybar --reload";

          # Starship prompt switcher
          "ctrl-alt-shift-v" =
            "exec-and-forget /bin/zsh -c 'source ~/.config/diaball/fns.sh; switch_starship_prompt'";

          # Media keys. AeroSpace's own volume command replaces the vol_up /
          # vol_down shell functions; its step size is macOS's, not 5.
          "ctrl-alt-shift-minus" = "volume down";
          "ctrl-alt-shift-equal" = "volume up";
          "ctrl-alt-shift-0" = "volume mute-toggle";
        };
      };
    };
  };
}
