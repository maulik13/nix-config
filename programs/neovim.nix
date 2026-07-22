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
      withRuby = true;
      withPython3 = true;
      initLua = ''
        vim.hl = vim.highlight
        vim.env.PATH = "${lib.makeBinPath [ pkgs.fzf ]}:" .. vim.env.PATH
        require("config.lazy")
      '';
    };
  };
}
