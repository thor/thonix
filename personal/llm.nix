{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
{
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
