{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
lib.mkIf isDarwin {
  # brew casks
  homebrew.casks = [
    # make mice scroll "normally" instead of "naturally"
    "scroll-reverser"
    # support a little stack thing
    "hammerspoon"
    # hide the notch
    "topnotch"
  ];

  environment.systemPackages = with pkgs; [
    # app starter which is much more useful than spotlight
    raycast
    # friendly terminal improvement
    iterm2
    # windows-style alt-tabbing
    alt-tab-macos
    # borders
    jankyborders
  ];

  launchd.user.agents.scroll-reverser = {
    command = "'/Applications/Scroll Reverser.app/Contents/MacOS/Scroll Reverser'";
    serviceConfig.KeepAlive = true;
    serviceConfig.ProcessType = "Interactive";
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # h, t, n, s
      alt - h : yabai -m query --windows --window west && yabai -m window --focus west || yabai -m display --focus west
      alt - t : yabai -m window --focus stack.next || yabai -m window --focus south
      alt - n : yabai -m window --focus stack.prev || yabai -m window --focus north
      alt - s : yabai -m query --windows --window east && yabai -m window --focus east || yabai -m display --focus east

      # spaces
      ctrl - 1 : yabai -m space --focus 1
      ctrl - 2 : yabai -m space --focus 2
      ctrl - 3 : yabai -m space --focus 3
      ctrl - 4 : yabai -m space --focus 4
      ctrl - 5 : yabai -m space --focus 5
      ctrl - 6 : yabai -m space --focus 6
      ctrl - 7 : yabai -m space --focus 7
      ctrl - 8 : yabai -m space --focus 8
      ctrl - 9 : yabai -m space --focus 9
      ctrl - 0 : yabai -m space --focus 10

      # spaces
      shift + lalt - 1 : yabai -m window --space 1; yabai -m space --focus 1
      shift + lalt - 2 : yabai -m window --space 2; yabai -m space --focus 2
      shift + lalt - 3 : yabai -m window --space 3; yabai -m space --focus 3
      shift + lalt - 4 : yabai -m window --space 4; yabai -m space --focus 4
      shift + lalt - 5 : yabai -m window --space 5; yabai -m space --focus 5
      shift + lalt - 6 : yabai -m window --space 6; yabai -m space --focus 6
      shift + lalt - 7 : yabai -m window --space 7; yabai -m space --focus 7
      shift + lalt - 8 : yabai -m window --space 8; yabai -m space --focus 8
      shift + lalt - 9 : yabai -m window --space 9; yabai -m space --focus 9
      shift + lalt - 0 : yabai -m window --space 9; yabai -m space --focus 10

      # move windows
      lalt + shift - h : yabai -m window --swap west
      lalt + shift - t : yabai -m window --swap south
      lalt + shift - n : yabai -m window --swap north
      lalt + shift - s : yabai -m window --swap east

      # go float
      lalt + shift - space : yabai -m window --toggle float
      # sticky window (f for follow)
      hyper - s : yabai -m window --toggle sticky

      # moving between monitors
      hyper - left : yabai -m space --display prev
      # hyper - t : yabai -m space --display last
      # hyper - n : yabai -m space --display first
      hyper - right : yabai -m space --display next

      # rebalance
      cmd + shift + alt - b : yabai -m space --balance

      # lean and clean, no gap machine
      cmd + shift + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

      # sort-of fullscreen (options: zoom-parent, zoom-fullscreen, native-fullscreen)
      cmd + shift + alt - f : yabai -m window --toggle zoom-parent
      cmd + shift + ctrl - f : yabai -m window --toggle zoom-fullscreen

      # toggle layout for the current space between bsp and float
      cmd + shift + alt - f : yabai -m space --layout "$(yabai -m query --spaces --space \
                              | jq -r 'if .type == "bsp" then "float" else "bsp" end')"

      # toggle layout for the current window between bsp and stack
      cmd + shift + alt - s : yabai -m window --stack next 
    '';
  };
}
