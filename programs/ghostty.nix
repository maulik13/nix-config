{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.ghostty;
in
{
  options.my.programs.ghostty = {
    enable = lib.mkEnableOption "My ghostty configuration";

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 18;
      description = "Font size for ghostty, overridable per machine";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "ghostty/config".source = ./../config/ghostty/config;
      "ghostty/themes/catppuccin-macchiato-custom".source =
        ./../config/ghostty/themes/catppuccin-macchiato-custom;
      "ghostty/themes/rosepine-moon-custom".source = ./../config/ghostty/themes/rosepine-moon-custom;
      "ghostty/machine".text = ''
        font-size = ${toString cfg.fontSize}
      '';
    };

    # Ghostty on macOS loads this path *in addition to* ~/.config/ghostty, and it
    # takes precedence. It is managed here (deliberately empty) so a stale
    # hand-written file can never silently override the config above.
    home.file."Library/Application Support/com.mitchellh.ghostty/config".text = ''
      # Managed by nix (programs/ghostty.nix). Intentionally empty: the real
      # configuration lives in ~/.config/ghostty/config.
    '';
  };
}
