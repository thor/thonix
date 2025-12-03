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
  ];

}
