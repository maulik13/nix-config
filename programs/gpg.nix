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

    # home-manager runs `gpg-agent --supervised` under launchd, but that mode
    # expects systemd-style fd passing (LISTEN_FDS) which launchd never
    # provides, so the job exits with code 2 and crash-loops forever. Disable it
    # and rely on the agent gpg spawns on demand via the standard socket.
    launchd.agents.gpg-agent.enable = lib.mkForce false;
  };
}
