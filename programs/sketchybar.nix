{
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.sketchybar;
in
{
  options.my.programs.sketchybar = {
    enable = lib.mkEnableOption "My sketchybar home configuration";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."sketchybar" = {
      source = ./../config/sketchybar;
      recursive = true;
    };
  };
}
