{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  # geesawra's fork carries the fix for macOS 27; upstream (and nixpkgs'
  # instant-space-switcher, which just fetches upstream's .dmg release) has
  # no build for it yet. There's no release binary for the fork either, so
  # this builds from source.
  #
  # TODO: rebase this on a newer commit once the fork moves, or drop it if
  # the fix lands upstream.
  instant-space-switcher = pkgs.stdenv.mkDerivation {
    pname = "instant-space-switcher";
    version = "geesawra-macos27-79a17c4";

    src = pkgs.fetchFromGitHub {
      owner = "geesawra";
      repo = "InstantSpaceSwitcher";
      rev = "79a17c4dd041639751a3d6087009864a2d6dcf1b";
      hash = "sha256-rK1+7cokE6zflnRqPZCRz9JcZlbLvWshkNTFaN8vkWw=";
    };

    # nixpkgs' swift package can't compile SwiftPM manifests against the
    # macOS 27 SDK, so this shells out to the system Xcode toolchain
    # instead. Needs sandboxing off (already the case on this machine)
    # since it reaches outside the nix store.
    __noChroot = true;

    buildPhase = ''
      runHook preBuild
      export PATH="/usr/bin:$PATH"
      unset DEVELOPER_DIR SDKROOT
      export DEVELOPER_DIR=/Library/Developer/CommandLineTools
      export SDKROOT=$(/usr/bin/xcrun --sdk macosx --show-sdk-path)
      swift build -c release --disable-sandbox
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications/InstantSpaceSwitcher.app/Contents/MacOS" "$out/bin"
      cp .build/release/InstantSpaceSwitcher .build/release/ISSCli \
        "$out/Applications/InstantSpaceSwitcher.app/Contents/MacOS/"
      cp Info.plist "$out/Applications/InstantSpaceSwitcher.app/Contents/"
      ln -s "$out/Applications/InstantSpaceSwitcher.app/Contents/MacOS/ISSCli" "$out/bin/isscli"
      # arm64 refuses to run an unsigned binary at all; ad-hoc sign it.
      /usr/bin/codesign --force --sign - "$out/Applications/InstantSpaceSwitcher.app"
      runHook postInstall
    '';

    dontFixup = true;

    meta = {
      description = "Instant native macOS space switching (geesawra's macOS 27 fork)";
      homepage = "https://github.com/geesawra/InstantSpaceSwitcher/tree/geesawra/macos27";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
      mainProgram = "isscli";
    };
  };
in
lib.mkIf isDarwin {
  environment.systemPackages = [ instant-space-switcher ];

  launchd.user.agents.instant-space-switcher = {
    command = "/Applications/Nix Apps/InstantSpaceSwitcher.app/Contents/MacOS/InstantSpaceSwitcher";
    serviceConfig.RunAtLoad = true;
  };

  # NOTE: ad-hoc signing means the app's identity changes every rebuild, so
  # macOS forgets the Accessibility grant each time and it needs re-approving
  # in System Settings.
}
