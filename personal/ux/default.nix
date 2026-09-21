{ pkgs, ... }:
let
  fonts = with pkgs; [
    fantasque-sans-mono
    nerd-fonts.fantasque-sans-mono
  ];
in
{
  # Setup my fants
  fonts.packages = fonts;

  imports = [
    ./darwin.nix
    ./yabai.nix
    # TODO: remove once yabai ships a working native space switcher on
    # macOS 27 (yabai.nix already carries a fork for the same reason).
    ./instant-space-switcher.nix
  ];

}
