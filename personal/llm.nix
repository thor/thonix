{ pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isDarwin;

  # Match pkgs/by-name/ol/ollama/package.nix version + fetchFromGitHub (nixos-unstable).
  ollama = pkgs.ollama.overrideAttrs (old: {
    version = "0.20.4";
    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v0.20.4";
      hash = "sha256-8TbZvxxaUdROpe3gnBx0XzX62tbQ9QeJP3Yp7XXJoTQ=";
    };
    vendorHash = "sha256-Lc1Ktdqtv2VhJQssk8K1UOimeEjVNvDWePE9WkamCos=";
  });
in
{
  environment.systemPackages = [
    ollama # local models
    pkgs.gemini-cli # open source cli with gemini access and mcp
  ];

  homebrew.casks = mkIf isDarwin [
    "chatgpt" # just another llm
    "antigravity" # google-esque cursor alternative, so-so
  ];

  homebrew.brews = mkIf isDarwin [
    "rtk" # reduce token usage
  ];
}
