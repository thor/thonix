# thor and nix: _thonix_

Such great fun, all provided in _one_ repository.

This is my weird adventure on a journey to understand how Nix, Nix, Nix, and Nix, all interact together in different ways.
Stable? Experimental? Who cares! It's all fun and games in the context of the de facto stabilised.

The configuration as provided in this repository provide a _flake_ for usage with `nix-darwin`, and potentially `home-manager`.

## Getting started

Assume your device is named the same as mine. I assume you have `nix` installed.

```sh
git clone git@github.com:thor/thonix.git $HOME/.config/thonix

# assuming you have nix, but you haven't got nix-darwin
# only do this once
pushd $HOME/.config/thonix
nix run nix-darwin/master#darwin-rebuild -- switch
popd

# once you have darwin-rebuild available, let's keep going
sudo ln -s $HOME/.config/thonix /etc/nix-darwin
darwin-rebuild switch
```
