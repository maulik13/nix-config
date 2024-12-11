{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.neovim;
in
{
  options.my.programs.neovim = {
    enable = lib.mkEnableOption "My neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
    };
  };
}
