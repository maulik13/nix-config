{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.skhd;
in
{
  options.my.programs.skhd = {
    enable = lib.mkEnableOption "My skhd configuration";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "skhd/skhdrc".source = ./../config/skhd/skhdrc;
    };
  };
}
