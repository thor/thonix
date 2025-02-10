{ pkgs, lib, ... }:
let
  fonts = with pkgs; [
    fantasque-sans-mono
    nerd-fonts.fantasque-sans-mono
  ];
in
{
  # Setup my fants
  fonts.packages = fonts;

  # brew casks
  homebrew.casks = [
    "scroll-reverser"
  ];

  environment.systemPackages = with pkgs; [
    # app starter which is much more useful than spotlight
    raycast
    # friendly terminal improvement
    iterm2
    # windows-style alt-tabbing
    alt-tab-macos
  ];
}
