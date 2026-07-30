{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.kitty;
in
{
  options.my.programs.kitty = {
    enable = lib.mkEnableOption "My kitty configuration";

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 18;
      description = "Font size for kitty, overridable per machine";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      # enable = true;
    };
    xdg.configFile = {
      "kitty/kitty.conf".source = ./../config/kitty/kitty.conf;
      "kitty/themes/catppuccin-macchiato-custom.conf".source =
        ./../config/kitty/themes/catppuccin-macchiato-custom.conf;
      "kitty/themes/rosepine-moon-custom.conf".source =
        ./../config/kitty/themes/rosepine-moon-custom.conf;
      "kitty/kitty.app.png".source = ./../config/kitty/kitty.app.png;
      "kitty/kitty.app.1.png".source = ./../config/kitty/kitty.app.1.png;
      "kitty/font-nerd-symbol.conf".source = ./../config/kitty/font-nerd-symbol.conf;
      "kitty/machine.conf".text = ''
        font_size ${toString cfg.fontSize}
      '';
    };
  };
}
