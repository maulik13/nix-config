{
  pkgs,
  lib,
  config,
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
    programs.yabai = {
      enable = true;
    };
    xdg.configFile = {
      "yabai/yabairc".source = ./../config/yabai/yabairc;
      "yabai/fns.sh".source = ./../config/yabai/fns.sh;
      "yabai/space.sh".source = ./../config/yabai/space.sh;
      "yabai/rules.sh".source = ./../config/yabai/rules.sh;
    };
  };
}
