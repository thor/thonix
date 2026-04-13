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
    "slp/krunkit/krunkit" # NOTE: should not be necessary, but alas it is for podman
    # "slp/krunkit/libkrun-efi" # NOTE: should not be necessary, but alas it is for padman
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
