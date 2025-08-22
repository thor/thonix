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

  # brew casks
  homebrew.casks = [
    "scroll-reverser"
    # delightful little temporary note app
    "antinote"
    "Kegworks-App/kegworks/kegworks"
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

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    extraConfig = ''
      # load scripting additions
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      sudo yabai --load-sa

      # managed, bsp, float
      yabai -m config layout bsp
      yabai -m config window_opacity_duration 0.04

      # Set all padding and gaps to 20pt (default: 0)
      yabai -m config window_gap     10
      yabai -m config top_padding    10
      yabai -m config bottom_padding 10
      yabai -m config left_padding   10
      yabai -m config right_padding  10

      # labels
      yabai -m space 1 --label cmd
      yabai -m space 2 --label web
      yabai -m space 3 --label com
      yabai -m space 4 --label mda
      yabai -m space 5 --label pri
      yabai -m space 6 --label 6
      yabai -m space 7 --label 7
      yabai -m space 8 --label wrk
      yabai -m space 9 --label priv

      # disable things
      yabai -m rule --add app='System..innstillinger' manage=off
      yabai -m rule --add app='Parallels Desktop' manage=off
      yabai -m rule --add app='Antinote' manage=off

      # gaps
      yabai -m space --padding 10

      # mouse interaction mode
      yabai -m config mouse_modifier alt

      # run jankyborders and configure it
      borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0 hidpi=on &

      # update raycast menubar
      yabai -m signal --add event=space_changed action="nohup open -g raycast://extensions/krzysztoff1/yabai/screens-menu-bar?launchType=background > /dev/null 2>&1 &"
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # h, t, n, s
      alt - h : yabai -m window --focus west
      alt - t : yabai -m window --focus south; yabai -m window --focus stack.next
      alt - n : yabai -m window --focus north; yabai -m window --focus stack.prev
      alt - s : yabai -m window --focus east

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
      # sticky window
      cmd + shift + alt - s : yabai -m window --toggle sticky

      # moving between monitors
      hyper - h : yabai -m space --display prev
      hyper - t : yabai -m space --display last
      hyper - n : yabai -m space --display first
      hyper - s : yabai -m space --display next

      # rebalance
      cmd + shift + alt - b : yabai -m space --balance

      # lean and clean, no gap machine
      cmd + shift + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

      # sort-of fullscreen (options: zoom-parent, zoom-fullscreen, native-fullscreen)
      cmd + shift + alt - f : yabai -m window --toggle zoom-parent
      cmd + shift + ctrl - f : yabai -m window --toggle zoom-fullscreen

      # toggle yabai layout
      cmd + shift + alt - l : [ "$(yabai -m query --spaces --space | jq -r .type)" = "bsp" ] \
                              && yabai -m space --layout float \
                              || yabai -m space --layout bsp
    '';
  };
}
