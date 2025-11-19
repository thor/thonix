{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;
in
{
  environment.systemPackages = with pkgs; [
    ollama # local models
    gemini-cli # open source cli with gemini access and mcp
  ];

  homebrew.casks = mkIf isDarwin [
    "antigravity"
  ];
}
