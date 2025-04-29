{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.programs.zellij;
in
{
  nixpkgs.overlays = with inputs; [
    (final: prev: {
      zjstatus = zjstatus.packages.${prev.system}.default;
    })
  ];
  options.my.programs.zellij = {
    enable = lib.mkEnableOption "My zellij home configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };
    home.shellAliases = {
      zj = "zellij";
    };
    home.packages = with pkgs; [
      zjstatus
    ];
    xdg.configFile = {
      "zellij/config.kdl".source = ./../config/zellij/config.kdl;
      "zellij/layouts".source = ./../config/zellij/layouts;
      "zellij/themes".source = ./../config/zellij/themes;
    };
  };
}
