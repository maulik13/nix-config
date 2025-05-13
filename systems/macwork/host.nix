{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../shared/host.nix
    ../../shared/darwin.nix
    ../../shared/brew.nix
  ];

  users.users.maulik = {
    description = "Maulik";
    home = "/Users/maulik";
    shell = pkgs.zsh;
  };

  networking.hostName = "mk-mac-work";

  system.stateVersion = 5;
}
