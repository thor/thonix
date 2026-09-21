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

## Useful commands

Build without activating, to test that it builds:

```sh
darwin-rebuild build --flake .#<hostname>
```

Just check it evaluates, no build:

```sh
darwin-rebuild build --flake .#<hostname> --dry-run
```

Build a single package:

```sh
nix build nixpkgs#<package>
```

Repair a store path whose contents got corrupted or edited (rebuilding will not fix this on its own):

```sh
sudo nix store repair /nix/store/<hash>-<name>
```

Verify and repair the whole store:

```sh
sudo nix store verify --all --repair
```

Update flake inputs:

```sh
nix flake update
```

### Pruning

Every `switch` leaves a generation behind, and each one pins its whole closure
in the store. Review them:

```sh
nix profile history --profile /nix/var/nix/profiles/system
```

Drop the ones older than 30 days, then free what nothing references anymore:

```sh
sudo nix profile wipe-history --older-than 30d --profile /nix/var/nix/profiles/system
nix profile wipe-history --older-than 30d
sudo nix store gc
```

`wipe-history` only prunes by age. To keep a fixed number of generations
instead, fall back to the legacy command:

```sh
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5
nix-env --delete-generations +5
```

`./result` is a garbage collection root, so delete it first or its whole system
build survives. `nix-store --gc --print-roots` shows what else is pinning paths,
and `sudo nix store optimise` hardlinks duplicates to reclaim a little more.

## Known issues

### Homebrew tap trust is written to the wrong store

`nix-homebrew` trusts non-official taps (`nix-homebrew.trust`) during activation.
Those `brew trust` calls run under `sudo`, which strips `XDG_CONFIG_HOME` from the
environment, so trust is written to `~/.homebrew/trust.json`. An interactive shell
sets `XDG_CONFIG_HOME`, so `brew` there reads `~/.config/homebrew/trust.json`
instead. The two stores diverge: taps trusted by activation appear untrusted in the
terminal.

`HOMEBREW_REQUIRE_TAP_TRUST` is on by default, which breaks builds. Also,
`brew bundle install --force-cleanup` (triggered by
`homebrew.onActivation.cleanup = "zap"`) wipes and rebuilds the whole trust store
from the current Brewfile on every activation. So anything `nix-homebrew.trust.taps`
sets gets thrown away before the next `brew cleanup` runs, no matter the store
mismatch above.

The workaround (for now) is to mark the tap itself `trusted = true` in
`homebrew.taps` (see `personal/brew.nix`), instead of using
`nix-homebrew.trust`. Homebrew can only keep trust for a bare-named formula or
cask if its tap is trusted, and that gets rebuilt fresh from the Brewfile every
run, so it survives the wipe.

Note: using a fully qualified cask or brew name (`"user/tap/name"` instead of
`"name"`) also survives the wipe, since its own `trusted: true` can be read
directly. But that only covers the one item you named, not its dependencies, since
those have no name in the Brewfile to qualify. Trusting the tap covers those too.
