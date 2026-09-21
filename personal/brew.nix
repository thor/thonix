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
    #
    # `trusted = true` is required for any tap whose formulae/casks are
    # referenced by bare name (not "tap/name") elsewhere, since Homebrew can
    # only derive persistent trust for a bare-named item from its tap being
    # trusted. Marking official taps trusted is a documented no-op, so this
    # is safe to apply to all of them.
    taps = map (name: {
      inherit name;
      trusted = true;
    }) (builtins.attrNames config.nix-homebrew.taps);

    # casks are configured elsewhere
  };

  nix-homebrew = {
    enable = true;

    user = config.system.primaryUser;

    # see homebrew.taps
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    # taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };
}
