{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.firefox;
in
{
  options.my.programs.firefox = {
    enable = lib.mkEnableOption "My Firefox configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      extensions = with pkgs.inputs.firefox-addons; [
        vimium
      ];
    };
  };
}
