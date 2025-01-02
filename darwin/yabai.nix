{
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.yabai;
in
{
  options.my.programs.yabai = {
    enable = lib.mkEnableOption "My yabai configuration";
  };

  config = lib.mkIf cfg.enable {
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        external_bar = "all:45:0";
        layout = "bsp";
        top_padding = 12;
        bottom_padding = 12;
        left_padding = 12;
        right_padding = 12;
        window_gap = 16;
        mouse_follows_focus = "off";
        focus_follows_mouse = "off";
        window_origin_display = "default";
        window_placement = "second_child";
        window_shadow = "off";
        window_opacity = "off";
        window_opacity_duration = 0.0;
        active_window_opacity = 1.0;
        normal_window_opacity = 0.85;
        insert_feedback_color = "0xaad75f5f";
        split_ratio = 0.5;
        auto_balance = "off";
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
        window_animation_duration = 0.1;
      };
      extraConfig = ''
        source $HOME/.config/yabai/fns.sh
        load

        # signals
        yabai -m signal --add event=window_destroyed active=yes action="yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse &> /dev/null || yabai -m window --focus \$(yabai -m query --windows --space | jq .[0].id) &> /dev/null"

        # On display change, reapply rules
        yabai -m signal --add event=display_added action="source $HOME/.config/yabai/fns.sh; load"
        yabai -m signal --add event=display_removed action="source $HOME/.config/yabai/fns.sh; load"

        borders &
      '';
    };
    xdg.configFile = {
      "yabai/fns.sh".source = ./../config/yabai/fns.sh;
      "yabai/spaces.sh".source = ./../config/yabai/spaces.sh;
      "yabai/rules.sh".source = ./../config/yabai/rules.sh;
    };
  };
}
