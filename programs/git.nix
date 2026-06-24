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
      signing.format = "openpgp";
      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
      ];
      settings = {
        user = {
          name = "maulik13";
          email = "maulik.kataria@gmail.com";
          # Resolve the signing key by UID/email instead of a hardcoded hex id,
          signingkey = "maulik.kataria@gmail.com";
        };
        commit.gpgsign = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        fetch.prune = true;
        tag.gpgSign = true;
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };

      includes = [
        {
          condition = "gitdir:~/work/";
          path = "~/.gitconfig-work";
        }
      ];
    };
    programs.delta.enable = true;
  };
}
