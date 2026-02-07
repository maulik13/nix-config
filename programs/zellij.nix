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
      zjstatus_cc location="file:///nix/store/2idg7848djd6099nfh5f0gkd0hlgzy26-zjstatus-0.22.0/bin/zjstatus.wasm" {

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

          format_left  "#[bg=$mauve,fg=$base] 󱜙  Claude #[fg=$mauve]"
          format_center "{pipe_status}{command_claude_status}"
          // Claude activity + context status
          pipe_status_format " {output}"
          pipe_status_rendermode "dynamic"

          border_enabled  "true"
          border_char     "─"
          border_format   "#[fg=$surface1]{char}"
          border_position "top"

          // Claude activity status — reads state pushed by hooks
          // Symlink is auto-created by the hook script at first run
          command_claude_status_command     "bash /tmp/claude-zellij-status/sync.sh"
          command_claude_status_format      " "
          command_claude_status_interval    "2"
          command_claude_status_rendermode  "static"
      }

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

          format_left  "{mode}#[bg=$mantle,fg=$text, regular] 󱓞  {session}#[fg=$mantle]"
          format_center "{tabs}"
          format_space  ""
          format_right "#[fg=$mantle]{command_host}"
          format_hide_on_overlength "true"
          format_precedence "crl"

          border_enabled  "false"
          border_char     "─"
          border_format   "#[fg=$surface1]{char}"
          border_position "top"

          mode_normal        "#[bg=$blue,fg=$mantle,bold] WORK "
          mode_locked        "#[bg=$surface2,fg=$mantle,bold] LOCKED  "
          mode_resize        "#[bg=$red,fg=$mantle,bold] RESIZE "
          mode_pane          "#[bg=$green,fg=$mantle,bold] PANE "
          mode_tab           "#[bg=$teal,fg=$mantle,bold] TAB "
          mode_scroll        "#[bg=$yellow,fg=$mantle,bold] SCROLL "
          mode_enter_search  "#[bg=$blue,fg=$mantle,bold] ENT-SEARCH "
          mode_search        "#[bg=$blue,fg=$mantle,bold] SEARCHARCH "
          mode_rename_tab    "#[bg=$teal,fg=$mantle,bold] RENAME-TAB "
          mode_rename_pane   "#[bg=$green,fg=$mantle,bold] RENAME-PANE "
          mode_session       "#[bg=$mauve,fg=$mantle,bold] SESSION "
          mode_move          "#[bg=$flamingo,fg=$mantle,bold] MOVE "
          mode_prompt        "#[bg=$sapphire,fg=$mantle,bold] PROMPT "
          mode_tmux          "#[bg=$peach,fg=$mantle,bold] TMUX "

          // formatting for inactive tabs
          tab_normal              "#[fg=$blue]#[bg=$blue,fg=$surface2,bold]{index} #[bg=$mantle,fg=$subtext1] {name}{floating_indicator}#[fg=$mantle]"
          tab_normal_fullscreen   "#[fg=$blue]#[bg=$blue,fg=$surface2,bold]{index} #[bg=$mantle,fg=$subtext1] {name}{fullscreen_indicator}#[fg=$mantle]"
          tab_normal_sync         "#[fg=$blue]#[bg=$blue,fg=$surface2,bold]{index} #[bg=$mantle,fg=$subtext1] {name}{sync_indicator}#[fg=$mantle]"

          // formatting for the current active tab
          tab_active              "#[fg=$peach]#[bg=$peach,fg=$surface2,bold]{index} #[bg=$peach,fg=$mantle,bold]{name}{floating_indicator}#[fg=$peach]"
          tab_active_fullscreen   "#[fg=$peach]#[bg=$peach,fg=$surface2,bold]{index} #[bg=$peach,fg=$mantle,bold]{name}{fullscreen_indicator}#[fg=$peach]"
          tab_active_sync         "#[fg=$peach]#[bg=$peach,fg=$surface2,bold]{index} #[bg=$peach,fg=$mantle,bold]{name}{sync_indicator}#[fg=$peach]"

          // separator between the tabs
          tab_separator           " "

          // indicators
          tab_sync_indicator       "  "
          tab_fullscreen_indicator "  "
          tab_floating_indicator   " 󰹙 "

          command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
          command_git_branch_format      "#[bg=$mantle,fg=blue] {stdout} "
          command_git_branch_interval    "10"
          command_git_branch_rendermode  "static"

          datetime        "#[bg=$mantle,fg=$surface0,bold] {format} "
          datetime_format "%A, %d %b %Y %H:%M"
          datetime_timezone "Europe/London"

          command_host_command    "uname -n"
          command_host_format     "#[bg=$mantle,fg=$flamingo]   {stdout} "
          command_host_interval   "0"
          command_host_rendermode "static"

          command_user_command    "whoami"
          command_user_format     "#[bg=$mantle,fg=$flamingo]   {stdout} "
          command_user_interval   "0"
          command_user_rendermode "static"

          // Claude activity + context status
          pipe_status_format "#[bg=$mantle,fg=$sky]󰮯  {output}"
          pipe_status_rendermode "dynamic"
        }
      }
  '';
  themeConfig = ''
    theme "catppuccin-macchiato"
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
