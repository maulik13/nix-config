{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.programs.gpg;
in
{
  options.my.programs.gpg = {
    enable = lib.mkEnableOption "My GnuPG configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      pinentry.package =
        if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
    };
  };
}
