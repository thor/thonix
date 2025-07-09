{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ollama # local models
    gemini-cli # open source cli with gemini access and mcp
  ];
}
