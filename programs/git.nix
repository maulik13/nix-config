{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.programs.git;
in
{
  options.my.programs.git = {
    enable = mkEnableOption "My git configuration";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "maulik13";
      userEmail = "maulik.kataria@gmail.com";
      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
      ];
      extraConfig = {
        user.signingkey = "FFA0E1C46DF8B004";
        commit.gpgsign = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        fetch.prune = true;
        tag.gpgSign = true;
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
      delta.enable = true;
    };
  };
}
