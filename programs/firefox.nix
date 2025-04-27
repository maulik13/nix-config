{
  pkgs,
  config,
  lib,
  inputs,
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
      profiles = {
        "tui-textfox" = {
          name = "tui-textfox";
          isDefault = true;
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            vimium
            firefox-color
            onepassword-password-manager
            lastpass-password-manager
          ];
          settings = {
            extensions.autoDisableScopes = 0;
          };
        };
      };
    };
  };
}
