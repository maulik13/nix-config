{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.programs.zellij;
  inherit (lib) strings;
  inherit (pkgs) stdenv theme zjstatus;
  pluginConfig = ''
    plugins {
      zjstatus location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
          // Catppuccin Machiatto
          color_rosewater "#f4dbd6"
          color_flamingo "#f0c6c6"
          color_pink "#f5bde6"
          color_mauve "#c6a0f6"
          color_red "#ed8796"
          color_maroon "#ee99a0"
          color_peach "#f5a97f"
          color_yellow "#eed49f"
          color_green "#a6da95"
          color_teal "#8bd5ca"
          color_sky "#91d7e3"
          color_sapphire "#7dc4e4"
          color_blue "#8aadf4"
          color_lavender "#b7bdf8"
          color_text "#cad3f5"
          color_subtext1 "#b8c0e0"
          color_subtext0 "#a5adcb"
          color_overlay2 "#939ab7"
          color_overlay1 "#8087a2"
          color_overlay0 "#6e738d"
          color_surface2 "#5b6078"
          color_surface1 "#494d64"
          color_surface0 "#363a4f"
          color_base "#24273a"
          color_mantle "#1e2030"
          color_crust "#181926"

          format_left  "#[bg=$base,fg=$text,bold]{mode}#[bg=$surface0,fg=$text] 󱓞 #[bg=$surface0,fg=$text,regular] {session}#[bg=$base,fg=$surface0]"
          format_center "#[bg=$base]{tabs}"
          format_space  ""
          # format_right "#[bg=$base,fg=$flamingo]#[fg=$base,bg=$flamingo]  #[bg=$surface0,fg=$flamingo] {command_host} "
          format_right "#[bg=$base,fg=$flamingo]#[fg=$base,bg=$flamingo]  #[bg=$surface0] {pipe_status} │ {command_host}"
          format_hide_on_overlength "true"
          format_precedence "crl"

          border_enabled  "false"
          border_char     "─"
          border_format   "#[fg=$surface1]{char}"
          border_position "top"

          mode_normal        "#[bg=$blue,fg=$surface0,bold] WORK "
          mode_locked        "#[bg=$surface2,fg=$surface0,bold] LOCKED  "
          mode_resize        "#[bg=$red,fg=$surface0,bold] RESIZE "
          mode_pane          "#[bg=$green,fg=$surface0,bold] PANE "
          mode_tab           "#[bg=$teal,fg=$surface0,bold] TAB "
          mode_scroll        "#[bg=$yellow,fg=$surface0,bold] SCROLL "
          mode_enter_search  "#[bg=$blue,fg=$surface0,bold] ENT-SEARCH "
          mode_search        "#[bg=$blue,fg=$surface0,bold] SEARCHARCH "
          mode_rename_tab    "#[bg=$teal,fg=$surface0,bold] RENAME-TAB "
          mode_rename_pane   "#[bg=$green,fg=$surface0,bold] RENAME-PANE "
          mode_session       "#[bg=$mauve,fg=$surface0,bold] SESSION "
          mode_move          "#[bg=$flamingo,fg=$surface0,bold] MOVE "
          mode_prompt        "#[bg=$sapphire,fg=$surface0,bold] PROMPT "
          mode_tmux          "#[bg=$peach,fg=$surface0,bold] TMUX "

          // formatting for inactive tabs
          tab_normal              "#[bg=$base,fg=$blue]#[bg=$blue,fg=$surface0,bold]{index} #[bg=$surface0,fg=$subtext1] {name}{floating_indicator}#[bg=$base,fg=$surface0]"
          tab_normal_fullscreen   "#[bg=$base,fg=$blue]#[bg=$blue,fg=$surface0,bold]{index} #[bg=$surface0,fg=$subtext1] {name}{fullscreen_indicator}#[bg=$base,fg=$surface0]"
          tab_normal_sync         "#[bg=$base,fg=$blue]#[bg=$blue,fg=$surface0,bold]{index} #[bg=$surface0,fg=$subtext1] {name}{sync_indicator}#[bg=$base,fg=$surface0]"

          // formatting for the current active tab
          tab_active              "#[bg=$base,fg=$peach]#[bg=$peach,fg=$base,bold]{index} #[bg=$peach,fg=$surface0,bold]{name}{floating_indicator}#[bg=$base,fg=$peach]"
          tab_active_fullscreen   "#[bg=$base,fg=$peach]#[bg=$peach,fg=$base,bold]{index} #[bg=$peach,fg=$surface0,bold]{name}{fullscreen_indicator}#[bg=$base,fg=$peach]"
          tab_active_sync         "#[bg=$base,fg=$peach]#[bg=$peach,fg=$base,bold]{index} #[bg=$peach,fg=$surface0,bold]{name}{sync_indicator}#[bg=$base,fg=$peach]"

          // separator between the tabs
          tab_separator           "#[bg=$base,fg=$base]█"

          // indicators
          tab_sync_indicator       "  "
          tab_fullscreen_indicator "  "
          tab_floating_indicator   " 󰹙 "

          command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
          command_git_branch_format      "#[fg=blue] {stdout} "
          command_git_branch_interval    "10"
          command_git_branch_rendermode  "static"

          datetime        "#[fg=$surface0,bold] {format} "
          datetime_format "%A, %d %b %Y %H:%M"
          datetime_timezone "Europe/London"

          command_host_command    "uname -n"
          command_host_format     "#[fg=$flamingo] {stdout}"
          command_host_interval   "0"
          command_host_rendermode "static"

          command_user_command    "whoami"
          command_user_format     "#[fg=$flamingo] {stdout}"
          command_user_interval   "0"
          command_user_rendermode "static"

          // Claude activity + context status
          pipe_status_format "#[fg=$sky]󰮯 {output}"
          pipe_status_rendermode "dynamic"
        }
      }
  '';
  themeConfig = ''
    theme "rose-pine-moon"
  '';
  staticConfig = builtins.readFile ./../config/zellij/static.kdl;
  platformSpecificConfig = strings.optionalString stdenv.isDarwin ''copy_command "pbcopy"'';
  configText = lib.concatLines [
    themeConfig
    platformSpecificConfig
    staticConfig
    pluginConfig
  ];
in
{
  options.my.programs.zellij = {
    enable = lib.mkEnableOption "My zellij home configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };
    home.shellAliases = {
      zj = "zellij -l welcome";
    };
    home.packages = [
      zjstatus
    ];
    xdg.configFile = {
      "zellij/layouts/default.kdl".source = ./../config/zellij/layouts/default.kdl;
      "zellij/themes".source = ./../config/zellij/themes;
      "zellij/config.kdl".text = configText;
    };
  };
}
