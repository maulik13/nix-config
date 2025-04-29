{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.starship;
in
{
  options.my.programs.starship = {
    enable = lib.mkEnableOption "My starship configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
    xdg.configFile."starship.toml" = {
      source = ../config/starship/rose-pine-moon.toml;
    };
  };
}
