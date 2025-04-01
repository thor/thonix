{ pkgs, ... }:
{
  # Barebones rust setup, limited to the analyzer for the time being in terms of fenix features
  environment.systemPackages = with pkgs; [
    rustup
    rust-analyzer-nightly
  ];
}
