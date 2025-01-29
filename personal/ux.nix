{ config, pkgs, ... }:
let
  fonts = with pkgs; [
    fantasque-sans-mono
  ];
in
{
  # Setup my fants
  fonts.packages = fonts;
  environment.systemPackages = with pkgs; [
    # app starter which is much more useful than spotlight
    raycast
    # friendly terminal improvement
    iterm2
  ];
}
