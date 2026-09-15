{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.herdr;
in
{
  options.my.programs.herdr = {
    enable = lib.mkEnableOption "My herdr configuration";
  };

  config = lib.mkIf cfg.enable {
    # Unlike the other program configs, this one is installed as a writable
    # copy rather than a store symlink: herdr rewrites config.toml at runtime
    # (the onboarding flag, and the theme when picked in the settings panel --
    # see src/app/config_io.rs upstream), and writing through a read-only
    # symlink fails. Nix stays the source of truth and each rebuild restores
    # the file, so changes made from herdr's settings panel do not survive a
    # `task update-osx`. Edit config/herdr/config.toml instead.
    home.activation.herdrConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run install -Dm 0644 \
        ${./../config/herdr/config.toml} \
        "$HOME/.config/herdr/config.toml"
    '';
  };
}
