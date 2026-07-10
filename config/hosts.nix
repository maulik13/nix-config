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

  current = {
    # LocalHostName reported by the current Apple Silicon Mac.
    hostname = "MKMBPM1P";
    dir = "macpersonal";
    arch = "aarch64-darwin";
    user = users.default;
  };
}
