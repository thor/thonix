{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Setup relevant homebrew packages
  homebrew = {
    enable = true;

    # Remove any formulae or casks that aren't configured in nix
    # Yes, do it even if brew is never fully clean.
    onActivation.cleanup = "zap";

    # interoperability with nix-homebrew
    taps = builtins.attrNames config.nix-homebrew.taps;

    # casks are configured elsewhere
  };

  nix-homebrew = {
    enable = true;

    user = config.system.primaryUser;

    # see homebrew.taps
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "Kegworks-App/homebrew-kegworks" = inputs.kegworks;
    };

    # taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };
}
