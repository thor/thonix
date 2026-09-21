{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
{
  # Build yabai from ImTheSquid's fork, which carries the scripting-addition
  # offsets for macOS 27. Nixpkgs still tracks asmvik/yabai.
  #
  # The fork sits on top of v7.1.25 and its makefile is byte-identical to
  # upstream's, so the nixpkgs postPatch/preBuild still apply.
  nixpkgs.overlays = [
    (
      final: prev:
      if !prev.stdenv.isDarwin then
        { }
      else
        {
          yabai = prev.yabai.overrideAttrs (old: {
            src = prev.fetchFromGitHub {
              owner = "ImTheSquid";
              repo = "yabai";
              rev = "3b463fc436829a936095ec6a9facf2de5faab680";
              hash = "sha256-BxXUJ8w8c5UiLN1H/v/PhIMsabkf9tY3jkkpcA21TI0=";
            };

            passthru = old.passthru // {
              rev = "3b463fc436829a936095ec6a9facf2de5faab680";
            };

            # Upstream's v7.1.25 changelog still describes this tree; only the
            # scripting addition differs.
            meta = old.meta // {
              homepage = "https://github.com/ImTheSquid/yabai";
            };
          });
        }
    )
  ];

  services.yabai = mkIf isDarwin {
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
      yabai -m config window_gap     5
      yabai -m config top_padding    5
      yabai -m config bottom_padding 5
      yabai -m config left_padding   5
      yabai -m config right_padding  5

      # labels
      yabai -m space 1 --label cmd
      yabai -m space 2 --label web
      yabai -m space 3 --label com
      yabai -m space 4 --label mda
      yabai -m space 5 --label pri
      yabai -m space 6 --label cal
      yabai -m space 7 --label note
      yabai -m space 8 --label wrk
      yabai -m space 9 --label priv

      # disable things
      ## not possible to resize properly
      yabai -m rule --add app='System..innstillinger' manage=off
      ## annoying to resize a vm
      yabai -m rule --add app='Parallels Desktop' manage=off
      ## tiny note stickers should be over 'em all
      yabai -m rule --add app='Antinote' manage=off
      ## native tabs only
      yabai -m rule --add app='Ghostty' manage=off
      ## password manager pop-up
      yabai -m rule --add role='AXWindow' app='Google.*Chrome' title='Bitwarden.*' manage=off label=bitwarden

      # mouse interaction mode
      yabai -m config mouse_modifier alt

      # run jankyborders and configure it
      borders active_color=0xccff9500 inactive_color=0xff494d64 width=3.0 hidpi=on &

      # update raycast menubar
      yabai -m signal --add event=space_changed action="nohup open -g raycast://extensions/krzysztoff1/yabai/screens-menu-bar?launchType=background > /dev/null 2>&1 &"
    '';
  };

  # see homebrew.taps
  nix-homebrew = mkIf isDarwin {
    taps = {
      "jackielii/homebrew-tap" = inputs.brew-jackielii;
    };
    trust = {
      taps = [
        "jackielii/tap"
      ];
    };
  };

  homebrew.casks = [ "jackielii/tap/skhd-zig" ];
}
