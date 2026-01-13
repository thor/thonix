{ pkgs, lib }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "jj-spr";
  version = "0.1.0-unstable-2025-01-13";

  src = pkgs.fetchFromGitHub {
    owner = "LucioFranco";
    repo = "jj-spr";
    rev = "93b0f224f477d01a753748e3390fa107917ef0f6";
    hash = "sha256-SM0tW4urrOCMw9BANVoh65G7zAMwtJw+F0LDInQHGxo=";
  };

  cargoHash = "sha256-3pBP8ZgKiKnE6fK4a9IVR67br33ktsmB5ofwTyy95wA=";

  # Build the spr crate specifically
  cargoBuildFlags = [ "-p" "jj-spr" ];
  cargoTestFlags = [ "-p" "jj-spr" ];

  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = [ pkgs.libgit2 ];

  env = {
    # Disable vendored libgit2
    LIBGIT2_NO_VENDOR = "1";
  };

  # Tests require jj (jujutsu) to be available
  doCheck = false;

  meta = with lib; {
    description = "The power tool for Jujutsu + GitHub workflows";
    homepage = "https://github.com/LucioFranco/jj-spr";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "jj-spr";
  };
}
