{
  config,
  lib,
  pkgs,
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

    # The app icon map ships from the same derivation as the font itself, so the
    # glyph names the plugins emit can never drift out of sync with the glyphs
    # the font actually provides. The font is installed via fonts.packages.
    xdg.configFile."sketchybar/plugins/icon_map.sh".source =
      "${pkgs.sketchybar-app-font}/bin/icon_map.sh";
  };
}
