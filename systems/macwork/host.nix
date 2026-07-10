{
  pkgs,
  inputs,
  host,
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

  networking.hostName = host.hostname;

  system.stateVersion = 5;
}
