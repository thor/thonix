{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
mkIf isDarwin {
  homebrew.brews = [
    "podman"
    "podman-compose"
    "slp/krun/krunkit" # NOTE: should not be necessary, but alas it is for podman
    "slp/krun/virglrenderer" # NOTE: should not be necessary, but alas it is for podman
  ];

  homebrew.casks = [
    "podman-desktop"
  ];

  nix-homebrew = {
    taps = {
      "slp/homebrew-krun" = inputs.krun;
    };
    trust = {
      taps = [
        "slp/krun"
      ];
    };
  };
}
