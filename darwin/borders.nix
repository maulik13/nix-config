{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.jankyborders;
in
{
  options.my.services.jankyborders = {
    enable = lib.mkEnableOption "My jankyborders configuration";
  };

  config = lib.mkIf cfg.enable {
    services.jankyborders = {
      enable = true;
      active_color = "0xffee99a0"; # Maroon
      inactive_color = "0x00000000";
      style = "round";
      width = 4.0;
      hidpi = "on";
    };
  };
}
