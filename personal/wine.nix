{ inputs, ... }:
{
  # see homebrew.taps
  nix-homebrew = {
    taps = {
      "Sikarugir-App/homebrew-sikarugir" = inputs.sikarugir;
    };
    trust = {
      taps = [ "slp/krunkit" ];
    };
  };

  # brew casks
  homebrew.casks = [
    "sikarugir"
  ];
}
