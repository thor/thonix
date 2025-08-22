{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.fenix.overlays.default ];

  # Barebones rust setup, limited to the analyzer for the time being in terms of fenix features
  environment.systemPackages = with pkgs; [
    gcc # added because a rust component needed it
    rustup
    # TODO: disable once https://github.com/nix-community/fenix/pull/202/files is merged
    # rust-analyzer-nightly
  ];
}
