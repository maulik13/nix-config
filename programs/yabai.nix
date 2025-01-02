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
    enable = lib.mkEnableOption "My yabai home configuration";
  };

  config = lib.mkIf cfg.enable {
    # xdg.configFile = {
    #   "yabai/fns.sh".source = ./../config/yabai/fns.sh;
    #   "yabai/spaces.sh".source = ./../config/yabai/spaces.sh;
    #   "yabai/rules.sh".source = ./../config/yabai/rules.sh;
    # };
  };
}
