{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # imports = [
  #   # Provide the full path to the kubeswitch.nix module
  #   "${inputs.nixpkgs}/nixos/modules/programs/kubeswitch.nix"
  # ];
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # services.postgresql = {
  #   enable = true;
  #   package = pkgs.postgresql_16;
  # };

  nix.nixPath = lib.mkForce [
    "nixpkgs=${inputs.nixpkgs}"
    "home-manager=${inputs.home-manager}"
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@admin"
    ];
  };
  nix.optimise.automatic = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.nix-daemon.enable = true;

  # This needs to be set to get the default system-level configuration, such
  # as completions for Nix and related tools. This is also required because on macOS
  # the $PATH doesn't include all the entries it should by default.
  programs = {
    zsh.enable = true;
    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs; [
    home-manager
    jq
    yq
  ];

  # Import the kubeswitch module directly

  # # Configure kubeswitch
  # programs.kubeswitch = {
  #   enable = true;
  #   commandName = "kubeswitch";
  # };

}
