{ inputs, ... }:
{
  # see homebrew.taps
  nix-homebrew = {
    taps = {
      "Sikarugir-App/homebrew-sikarugir" = inputs.sikarugir;
    };
  };

  # brew casks
  homebrew.casks = [
    "sikarugir"
  ];
}
