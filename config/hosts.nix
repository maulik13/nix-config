let
  users = import ./users.nix;
in
{
  work = {
    hostname = "mk-mac-work";
    dir = "macwork";
    arch = "aarch64-darwin";
    user = users.default;
  };
}
