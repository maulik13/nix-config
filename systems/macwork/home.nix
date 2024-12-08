{ osConfig, ... }:
let
  language = name: text: text;
in
{
  imports = [
    ../../shared/home.nix
  ];

  # The homeDirectory is configured by each host's configuration because it's
  # not constant between linux and macos
  home.homeDirectory = "/Users/maulik";
  home.stateVersion = "24.05";

  # Interestingly this is actually broken in macOS! I went on a deep-dive
  # and eventually found that the Zed team has run into this issue as well.
  # https://github.com/zed-industries/community/issues/1373#issuecomment-1499033975
  home.file.".hushlogin".text = "";
}
