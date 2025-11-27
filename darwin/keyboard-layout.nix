{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.custom.keyboard.layout = mkOption {
    type = types.nullOr types.path;
    default = null;
    description = "Path to a custom .keylayout file or .bundle directory to install.";
  };

  config = {
    system.activationScripts.postActivation.text = lib.mkForce ''
      TRACKING_FILE="/var/db/.nix-custom-keyboard-layout-installed"
      TARGET_DIR="/Library/Keyboard Layouts"
      
      # The nix store path includes a hash, e.g., /nix/store/...-my.keylayout or ...-my.bundle
      # We want to install it as just "my.keylayout" or "my.bundle"
      # basename gives us "hash-my.keylayout"
      CLEAN_NAME=$(basename "${toString config.custom.keyboard.layout}")

      # 1. Clean up old layout if the name changed
      if [ -f "$TRACKING_FILE" ]; then
        OLD_NAME=$(cat "$TRACKING_FILE")
        if [ -n "$OLD_NAME" ] && [ "$OLD_NAME" != "$CLEAN_NAME" ]; then
           if [ -e "$TARGET_DIR/$OLD_NAME" ]; then
             echo "Removing old keyboard layout: $OLD_NAME"
             rm -rf "''${TARGET_DIR:?}/''${OLD_NAME:?}" "''${TRACKING_FILE:?}"
           fi
        fi
      fi
      
      ${lib.optionalString (config.custom.keyboard.layout != null) ''
        echo "Setting up custom keyboard layout: $CLEAN_NAME" >&2

        # 2. Install new layout (overwrite existing with same name)
        rm -rf "''${TARGET_DIR:?}/''${CLEAN_NAME:?}"
        ${pkgs.coreutils}/bin/cp -R "${config.custom.keyboard.layout}" "''${TARGET_DIR:?}/''${CLEAN_NAME:?}"

        # 3. Update tracking file
        echo "$CLEAN_NAME" > "$TRACKING_FILE"
      ''}
    '';
  };
}
