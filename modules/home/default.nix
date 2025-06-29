{ ... }:
{
  imports =
    (map (p: ../../programs + "/''${p}")
      (builtins.attrNames (builtins.readDir ../../programs)));
}
