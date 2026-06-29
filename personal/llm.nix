{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
{
  # herdr vendors libghostty-vt (a Zig library) whose build calls
  # LibCInstallation.findNative. Zig 0.15 ignores SDKROOT and instead runs
  # `xcode-select --print-path` then `xcrun --sdk macosx --show-sdk-path`.
  # Neither works in the Nix sandbox, so we shim both to return the nix SDK path.
  # Remove once the herdr nixpkgs derivation adds apple-sdk on Darwin.
  nixpkgs.overlays = [
    # Do not use module-level `lib` inside this closure — it goes through
    # _module.args.lib → pkgs.lib → overlays, creating infinite recursion.
    # Use `prev.*` or plain Nix `if` expressions instead.
    (final: prev:
      if !prev.stdenv.isDarwin then { }
      else
        let
          sdkRoot = "${final.apple-sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
          xcodeShims = final.symlinkJoin {
            name = "xcode-shims";
            paths = [
              (final.writeShellScriptBin "xcode-select" ''
                echo "${final.apple-sdk}"
              '')
              (final.writeShellScriptBin "xcrun" ''
                while [[ $# -gt 0 ]]; do
                  case "$1" in
                    --show-sdk-path) echo "${sdkRoot}"; exit 0 ;;
                  esac
                  shift
                done
                exit 1
              '')
            ];
          };
        in
        {
          herdr = prev.herdr.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ final.apple-sdk final.darwin.cctools xcodeShims ];
          });
        }
    )
  ];

  environment.systemPackages = with pkgs; [
    ollama # local models
    opencode # local agentic approach
    gemini-cli # open source cli with gemini access and mcp
    herdr # llm multiplexer
  ];

  homebrew.casks = mkIf isDarwin [
    "chatgpt" # just another llm
    "antigravity" # google-esque cursor alternative, so-so
    "claude-code@latest" # claude code
  ];

  homebrew.brews = mkIf isDarwin [
    "rtk" # reduce token usage
  ];
}
