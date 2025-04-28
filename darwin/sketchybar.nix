{ config, lib, ... }:

let
  cfg = config.my.services.sketchybar;
in
{
  options.my.services.sketchybar = {
    enable = lib.mkEnableOption "My SketchyBar configuration";
  };

  config = lib.mkIf cfg.enable {
    services.sketchybar = {
      enable = true;
    };
  };
}
