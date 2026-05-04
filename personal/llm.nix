{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
{
  environment.systemPackages = [
    pkgs.ollama # local models
    pkgs.gemini-cli # open source cli with gemini access and mcp
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
