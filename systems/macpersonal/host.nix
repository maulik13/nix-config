{ ... }:
{
  # Keep this Mac aligned with the shared work-Mac system configuration.
  # Add personal-machine-only nix-darwin settings here as needed.
  imports = [
    ../macwork/host.nix
  ];
}
