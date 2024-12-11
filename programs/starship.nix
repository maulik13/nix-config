{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.programs.starship;
in
{
  options.my.programs.starship = {
    enable = mkEnableOption "My starship configuration";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = lib.readFile ../config/starship/clean.toml;
    };
  };
}
