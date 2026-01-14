{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
mkIf isDarwin {
  homebrew.brews = [
    "podman"
    "podman-compose"
    "krunkit"
  ];

  homebrew.casks = [
    "podman-desktop"
  ];

  nix-homebrew = {
    taps = {
      "slp/homebrew-krunkit" = inputs.krunkit;
    };
  };
}
