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

      # disable things
      yabai -m rule --add app='System..innstillinger' manage=off

      # gaps
      yabai -m space --padding 10

      # mouse interaction mode
      yabai -m config mouse_modifier alt

      # run jankyborders and configure it
      borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0 hidpi=on &
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

      # move windows
      lalt + shift - h : yabai -m window --swap west
      lalt + shift - t : yabai -m window --swap south
      lalt + shift - n : yabai -m window --swap north
      lalt + shift - s : yabai -m window --swap east

      # go float
      lalt + shift - space : yabai -m window --toggle float

      # moving between monitors
      hyper - h : yabai -m space --display prev
      hyper - t : yabai -m space --display last
      hyper - n : yabai -m space --display first
      hyper - s : yabai -m space --display next
    '';
  };
}
